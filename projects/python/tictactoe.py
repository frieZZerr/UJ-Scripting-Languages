#!/usr/bin/env python3

import random
import sys
from math import inf as infinity

BOARD = ["-" for _ in range(9)]
END_GAME = 0
AI = 0
PLAYER = "X"

args = sys.argv

def display_facts():
    print("  - Games played on three-in-a-row boards can be traced back to ancient Egypt, where such game boards have been found on roofing tiles dating from around 1300 BC.")
    print("  - 19,683 is the number of all possible games.")
    print("  - The minimum number of moves to win a game is 5.")
    print("  - The maximum number of moves in any game is 9.")
    print("  - Total number of final filled boards containing 5 X’s and 4 O’s is 126.")
    exit(0)

def display_help():
    print("This script allows to play tic-tac-toe on a 3x3 board.")
    print("Script has 2 modes: Player-vs-Player and Player-vs-AI.")
    print("Players take turns placing 'X' or 'O' marks on the board to win by getting three marks in a row (vertically, horizontally, or diagonally).")
    print("The board is displayed after each move, and the game ends with a victory for one player or a draw.\n")
    print("Usage: python3 tictactoe.py [options]".format(__file__))
    print("Options:")
    print("  -h, --help     Display this help message")
    print("  --facts        Display some interesting facts about tic-tac-toe")
    print("* Any other options will be ignored")
    exit(0)

for arg in args:
    if arg == "-h" or arg == "--help":
        display_help()
    
    if arg == "--facts":
        display_facts()

def display_board():
    for i in range(0, 9, 3):
        print(" {} | {} | {} ".format(BOARD[i], BOARD[i+1], BOARD[i+2]))
        print("-----------")

def wins(local_board, player):
    win_state = [
        [local_board[0], local_board[1], local_board[2]],
        [local_board[3], local_board[4], local_board[5]],
        [local_board[6], local_board[7], local_board[8]],
        [local_board[0], local_board[3], local_board[6]],
        [local_board[1], local_board[4], local_board[7]],
        [local_board[2], local_board[5], local_board[8]],
        [local_board[0], local_board[4], local_board[8]],
        [local_board[2], local_board[4], local_board[6]],
    ]

    if [player, player, player] in win_state:
        return True
    else:
        return False

def evaluate(local_board):
    if wins(local_board, "O"):
        score = +1
    elif wins(local_board, "X"):
        score = -1
    else:
        score = 0

    return score

def minimax(local_board, depth, player):
    if player == "O":
        best = [-1, -infinity]
    else:
        best = [-1, +infinity]

    if depth == 0 or wins(local_board, "O") or wins(local_board, "X"):
        score = evaluate(local_board)
        return [-1, score]

    for cell in get_available_moves(local_board):
        local_board[cell-1] = player

        next_player = ""
        if player == "O":
            next_player = "X"
        else:
            next_player = "O"
        score = minimax(local_board, depth-1, next_player)

        local_board[cell-1] = "-"

        score[0] = cell

        if player == "O":
            if score[1] > best[1]:
                best = score  # max value
        else:
            if score[1] < best[1]:
                best = score  # min value

    return best

def ai_move(available_moves):
    local_board = BOARD.copy()
    move = minimax(local_board, len(available_moves), "O")[0]
    return move

def get_available_moves(local_board):
    available_moves = [i+1 for i in range(9) if local_board[i] == "-"]
    return available_moves

def update_board(move):
    global BOARD, PLAYER
    BOARD[move] = PLAYER

def switch_player():
    global PLAYER
    PLAYER = "O" if PLAYER == "X" else "X"

def check_tie(available_moves):
    if not available_moves:
        print("It's a tie! The board is full\n")
        sleep(2)
        reset_board()
        clear()
        return True
    return False

def save_game():
    clear()
    filename = input("Enter the filename to save the game: ") + ".txt"
    with open(filename, "w") as f:
        f.write(" ".join(BOARD) + "\n")
        f.write(PLAYER + "\n")
        f.write(str(END_GAME) + "\n")
        f.write(str(AI) + "\n")
    print(f"Game saved successfully to file: {filename}\n")

def load_game():
    clear()
    global BOARD, PLAYER, END_GAME, AI
    filename = input("Enter the filename to load the game: ") + ".txt"
    try:
        with open(filename, "r") as f:
            data = f.readlines()
            BOARD = data[0].split()
            PLAYER = data[1].strip()
            END_GAME = int(data[2])
            AI = int(data[3])
    except FileNotFoundError:
        print(f"Cannot find file: {filename}\n")
        END_GAME = 1

def play():
    global END_GAME, PLAYER
    while True:
        clear()
        display_board()

        if AI == 1:
            if PLAYER == "X":
                move = input("Player X's turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: ")
            else:
                available_moves = get_available_moves(BOARD)
                if check_tie(available_moves):
                    break

                move = ai_move(available_moves)
                if move == -1:
                    move = random.choice(available_moves)
                
                print(f"Computer (O) chooses {move}")
                sleep(1)
        else:
            available_moves = get_available_moves(BOARD)
            if check_tie(available_moves):
                break
            move = input(f"Player {PLAYER}'s turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: ")

        if move == "Q":
            print("Game aborted.\n")
            break

        if move == "S":
            save_game()
            break

        try:
            move = int(move)
            if move not in range(1, 10) or BOARD[move-1] != "-":
                raise Exception
        except Exception:
            print("Invalid move. Please try again.\n")
            sleep(1)
            continue

        update_board(move-1)

        if wins(BOARD, PLAYER):
            clear()
            display_board()
            print(f"Player {PLAYER} wins!\n")
            sleep(2)
            reset_board()
            clear()
            break

        switch_player()

def reset_board():
    global BOARD, END_GAME, PLAYER
    BOARD = ["-" for _ in range(9)]
    END_GAME = 0
    PLAYER = "X"

def menu():
    clear()
    reset_board()
    while True:
        print("Menu:")
        print("1. New Game (Player vs Player)")
        print("2. New Game (Player vs AI)")
        print("3. Load Game")
        print("4. Quit")
        choice = input("Enter your choice (1-4): ")

        if choice == "1":
            global AI
            AI = 0
            reset_board()
            play()
        elif choice == "2":
            AI = 1
            reset_board()
            play()
        elif choice == "3":
            load_game()
            if END_GAME == 1:
                continue
            else:
                play()
        elif choice == "4":
            print("\nQuitting game...")
            print("Thanks for playing!\n")
            break
        else:
            clear()
            print("\nInvalid choice. Please enter a number between 1 and 4.\n")

if __name__ == "__main__":
    import os
    from time import sleep

    clear = lambda: os.system("clear")
    menu()
