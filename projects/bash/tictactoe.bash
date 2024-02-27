#!/usr/bin/bash

BOARD=(- - - - - - - - -)
END_GAME=0
AI=0
PLAYER="X"

win_state=(
    "0 1 2"
    "3 4 5"
    "6 7 8"
    "0 3 6"
    "1 4 7"
    "2 5 8"
    "0 4 8"
    "2 4 6"
)

display_facts() {
    echo "  - Games played on three-in-a-row boards can be traced back to ancient Egypt, where such game boards have been found on roofing tiles dating from around 1300 BC."
    echo "  - 19,683 is the number of all possible games."
    echo "  - The minimum number of moves to win a game is 5."
    echo "  - The maximum number of moves in any game is 9."
    echo "  - Total number of final filled boards containing 5 X’s and 4 O’s is 126."
    exit 0
}

display_help() {
    echo "This script allows to play tic-tac-toe on a 3x3 board."
    echo "Script has 2 modes: Player-vs-Player and Player-vs-AI."
    echo "Players take turns placing 'X' or 'O' marks on the board to win by getting three marks in a row (vertically, horizontally, or diagonally)."
    echo "The board is displayed after each move, and the game ends with a victory for one player or a draw."
    echo ""
    echo "Usage: ./tictactoe.sh [options]"
    echo "Options:"
    echo "  -h, --help     Display this help message"
    echo "  --facts        Display some interesting facts about tic-tac-toe"
    echo "* Any other options will be ignored"
    exit 0
}

for arg in "$@"; do
    if [[ $arg == "-h" || $arg == "--help" ]]; then
        display_help
    fi

    if [[ $arg == "--facts" ]]; then
        display_facts
    fi
done

display_board() {
    for ((i = 0; i < 9; i += 3)); do
        echo " ${BOARD[i]} | ${BOARD[i+1]} | ${BOARD[i+2]} "
        echo "-----------"
    done
}

check_win() {
    local local_board=("${BOARD[@]}")
    local available_moves=("$@")
    local move=0
    local players=(O X)

    for player in "${players[@]}"; do
        for i in "${available_moves[@]}"; do
            if [[ move -ne 0 ]]; then
                break
            fi

            local_board[$i-1]=$player

            if wins local_board[@] $player; then
                move=$i
            fi

            local_board=("${BOARD[@]}")
        done
    done
    echo "$move"
}

wins() {
    local local_board=("${!1}")
    local player=$2
    for win in "${win_state[@]}"; do
        local cells=($win)
        local pattern=""
        for cell in "${cells[@]}"; do
            pattern+="${local_board[cell]}"
        done
        if [[ $pattern == *"$player$player$player"* ]]; then
            return 0
        fi
    done
    return 1
}

get_available_moves() {
    local -a local_board=("${!1}")
    local available_moves=()
    for ((i = 0; i < 9; i++)); do
        if [[ ${local_board[i]} == "-" ]]; then
            available_moves+=("$((i + 1))")
        fi
    done
    echo "${available_moves[@]}"
}

update_board() {
    local move=$1
    BOARD[move]=$PLAYER
}

switch_player() {
    if [[ $PLAYER == "X" ]]; then
        PLAYER="O"
    else
        PLAYER="X"
    fi
}

check_tie() {
    local -a available_moves=("$@")
    if [[ ${#available_moves[@]} -eq 0 ]]; then
        echo "It's a tie! The board is full"
        sleep 2
        reset_board
        clear
        return 0
    fi
    return 1
}

save_game() {
    local filename
    read -p "Enter the filename to save the game: " filename
    filename="${filename}.txt"
    {
        echo "${BOARD[*]}"
        echo "$PLAYER"
        echo "$END_GAME"
        echo "$AI"
    } > "$filename"
    clear
    echo -e "Game saved successfully to file: $filename\n\n"
}

load_game() {
    clear
    echo "Enter the filename to load the game:"
    read -r filename
    filename="${filename}.txt"
    if [[ -f $filename ]]; then
        if [ "$(cat ${filename} | sed -n '1p')" != "" ]; then
            BOARD=($(cat ${filename} | sed -n '1p'))
        fi
        if [ "$(cat ${filename} | sed -n '2p')" != "" ]; then
            PLAYER=$(cat ${filename} | sed -n '2p')
        fi
        if [ "$(cat ${filename} | sed -n '3p')" != "" ]; then
            END_GAME=$(cat ${filename} | sed -n '3p')
        fi
        if [ "$(cat ${filename} | sed -n '4p')" != "" ]; then
            AI=$(cat ${filename} | sed -n '4p')
        fi
    else
        clear
        echo -e "Cannot find file: $filename\n\n"
        END_GAME=1
    fi
}

play() {
    while true; do
        clear
        display_board

        local move
        if ((AI == 1)); then
            if [[ $PLAYER == "X" ]]; then
                echo -n "Player X's turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: "
                read -r move
            else
                local -a available_moves=($(get_available_moves BOARD[@]))
                if check_tie "${available_moves[@]}"; then
                    break
                fi
                move=($(check_win "${available_moves[@]}"))
                if [[ $move -eq 0 ]]; then
                    move=${available_moves[$((RANDOM % ${#available_moves[@]}))]}
                fi
                echo "Computer (O) chooses $move"
                sleep 1
            fi
        else
            local -a available_moves=($(get_available_moves BOARD[@]))
            if check_tie "${available_moves[@]}"; then
                break
            fi
            echo -n "Player $PLAYER's turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: "
            read -r move
        fi

        if [[ $move == "Q" ]]; then
            clear
            echo "Game aborted."
            break
        fi

        if [[ $move == "S" ]]; then
            save_game
            break
        fi

        if ! [[ $move =~ ^[1-9]$ && ${BOARD[move - 1]} == "-" ]]; then
            echo "Invalid move. Please try again."
            sleep 1
            continue
        fi

        update_board "$((move - 1))"

        if wins BOARD[@] "$PLAYER"; then
            clear
            display_board
            echo "Player $PLAYER wins!"
            sleep 2
            reset_board
            clear
            break
        fi

        switch_player
    done
}

reset_board() {
    BOARD=(- - - - - - - - -)
    END_GAME=0
    PLAYER="X"
}

menu() {
    clear
    reset_board
    while true; do
        echo "Menu:"
        echo "1. New Game (Player vs Player)"
        echo "2. New Game (Player vs AI)"
        echo "3. Load Game"
        echo "4. Quit"
        echo -n "Enter your choice (1-4): "
        read -r choice

        case $choice in
            1)
                AI=0
                reset_board
                play
                ;;
            2)
                AI=1
                reset_board
                play
                ;;
            3)
                load_game
                if ((END_GAME == 1)); then
                    continue
                else
                    play
                fi
                ;;
            4)
                echo -e "\nQuitting game..."
                echo -e "Thanks for playing!\n"
                break
                ;;
            *)
                clear
                echo -e "\nInvalid choice. Please enter a number between 1 and 4.\n"
                ;;
        esac
    done
}

menu
