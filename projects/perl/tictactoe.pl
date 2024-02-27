#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw(first);

my @BOARD = ("-") x 9;
my $END_GAME = 0;
my $AI = 0;
my $PLAYER = "X";

my @win_state = (
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
);

sub display_facts {
    print("  - Games played on three-in-a-row boards can be traced back to ancient Egypt, where such game boards have been found on roofing tiles dating from around 1300 BC.\n");
    print("  - 19,683 is the number of all possible games.\n");
    print("  - The minimum number of moves to win a game is 5.\n");
    print("  - The maximum number of moves in any game is 9.\n");
    print("  - Total number of final filled boards containing 5 X’s and 4 O’s is 126.\n");
    exit(0);
}

sub display_help {
    print("This script allows to play tic-tac-toe on a 3x3 board.\n");
    print("Script has 2 modes: Player-vs-Player and Player-vs-AI.\n");
    print("Players take turns placing 'X' or 'O' marks on the board to win by getting three marks in a row (vertically, horizontally, or diagonally).\n");
    print("The board is displayed after each move, and the game ends with a victory for one player or a draw.\n\n");
    print("Usage: ./tictactoe.pl [options]\n");
    print("Options:\n");
    print("  -h, --help     Display this help message\n");
    print("  --facts        Display some interesting facts about tic-tac-toe\n");
    print("* Any other options will be ignored\n");
    exit(0);
}

foreach my $arg (@ARGV) {
    if ($arg eq "-h" or $arg eq "--help") {
        display_help();
    }

    if ($arg eq "--facts") {
        display_facts();
    }
}

sub display_board {
    for (my $i = 0; $i < 9; $i += 3) {
        print(" $BOARD[$i] | $BOARD[$i+1] | $BOARD[$i+2] \n");
        print("-----------\n");
    }
}

sub wins {
    my ($local_board, $player) = @_;
    foreach my $win (@win_state) {
        if (join("", map { $local_board->[$_] } @$win) eq $player x 3) {
            return 1;
        }
    }
    return 0;
}

sub evaluate {
    my ($local_board) = @_;
    if (wins($local_board, "O")) {
        return 1;
    } elsif (wins($local_board, "X")) {
        return -1;
    } else {
        return 0;
    }
}

sub minimax {
    my ($local_board, $depth, $player) = @_;
    
    my $best;
    if ($player eq "O") {
        $best = [-1, -\*inf];
    } else {
        $best = [-1, +\*inf];
    }

    if ($depth == 0 or wins($local_board, "O") or wins($local_board, "X")) {
        my $score = evaluate($local_board);
        return [-1, $score];
    }

    my ($available_moves) = get_available_moves(\@$local_board);

    foreach my $cell (@$available_moves) {
        $local_board->[$cell - 1] = $player;
        my $next_player = $player eq "O" ? "X" : "O";
        my $score = minimax($local_board, $depth - 1, $next_player);
        $local_board->[$cell - 1] = "-";
        $score->[0] = $cell;

        if ($player eq "O") {
            if ($score->[1] > $best->[1]) {
                $best = $score;  # max value
            }
        } else {
            if ($score->[1] < $best->[1]) {
                $best = $score;  # min value
            }
        }
    }
    return $best;
}

sub ai_move {
    my ($available_moves) = @_;
    my $move = minimax(\@BOARD, scalar @$available_moves, "O")->[0];
    return $move;
}

sub get_available_moves {
    my ($local_board) = @_;
    my @available_moves;
    for (my $i = 0; $i < 9; $i++) {
        push @available_moves, $i + 1 if $local_board->[$i] eq "-";
    }
    return \@available_moves;
}

sub update_board {
    my ($move) = @_;
    $BOARD[$move] = $PLAYER;
}

sub switch_player {
    $PLAYER = $PLAYER eq "X" ? "O" : "X";
}

sub check_tie {
    my ($available_moves) = @_;
    unless (@$available_moves) {
        print("It's a tie! The board is full\n");
        sleep(2);
        reset_board();
        clear();
        return 1;
    }
    return 0;
}

sub save_game {
    clear();
    print("Enter the filename to save the game: ");
    my $filename = <STDIN>;
    chomp $filename;
    open(my $fh, ">", "$filename.txt") or die "Cannot open file $filename.txt: $!";
    print $fh join(" ", @BOARD) . "\n";
    print $fh $PLAYER . "\n";
    print $fh $END_GAME . "\n";
    print $fh $AI . "\n";
    close($fh);
    print("Game saved successfully to file: $filename.txt\n\n");
}

sub load_game {
    clear();
    print("Enter the filename to load the game: ");
    my $filename = <STDIN>;
    chomp $filename;
    if (-e "$filename.txt") {
        open(my $fh, "<", "$filename.txt") or die "Cannot open file $filename.txt: $!";
        @BOARD = split(" ", <$fh>);
        $PLAYER = <$fh>;
        chomp $PLAYER;
        $END_GAME = <$fh>;
        $AI = <$fh>;
        close($fh);
    } else {
        print("Cannot find file: $filename.txt\n\n");
        $END_GAME = 1;
    }
}

sub play {
    while (1) {
        clear();
        display_board();

        my $move;
        if ($AI == 1) {
            if ($PLAYER eq "X") {
                print("Player X's turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: ");
                $move = <STDIN>;
                chomp $move;
            } else {
                my $available_moves = get_available_moves(\@BOARD);
                if (check_tie($available_moves)) {
                    last;
                }
                $move = ai_move($available_moves);
                if ($move == -1) {
                    $move = $available_moves->[int rand @$available_moves];
                }
                print("Computer (O) chooses $move\n");
                sleep(1);
            }
        } else {
            my $available_moves = get_available_moves(\@BOARD);
            if (check_tie($available_moves)) {
                last;
            }
            print("Player $PLAYER\'s turn. Enter a number (1-9), 'S' to save, or 'Q' to quit: ");
            $move = <STDIN>;
            chomp $move;
        }

        if ($move eq "Q") {
            clear();
            print("Game aborted.\n");
            last;
        }

        if ($move eq "S") {
            save_game();
            last;
        }

        eval {
            $move = int($move);
            die unless ($move >= 1 and $move <= 9 and $BOARD[$move - 1] eq "-");
        };
        if ($@) {
            print("Invalid move. Please try again.\n");
            sleep(1);
            next;
        }

        update_board($move - 1);

        if (wins(\@BOARD, $PLAYER)) {
            clear();
            display_board();
            print("Player $PLAYER wins!\n");
            sleep(2);
            reset_board();
            clear();
            last;
        }

        switch_player();
    }
}

sub reset_board {
    @BOARD = ("-") x 9;
    $END_GAME = 0;
    $PLAYER = "X";
}

sub menu {
    clear();
    reset_board();
    while (1) {
        print("Menu:\n");
        print("1. New Game (Player vs Player)\n");
        print("2. New Game (Player vs AI)\n");
        print("3. Load Game\n");
        print("4. Quit\n");
        print("Enter your choice (1-4): ");
        my $choice = <STDIN>;
        chomp $choice;

        if ($choice eq "1") {
            $AI = 0;
            reset_board();
            play();
        } elsif ($choice eq "2") {
            $AI = 1;
            reset_board();
            play();
        } elsif ($choice eq "3") {
            load_game();
            if ($END_GAME == 1) {
                next;
            } else {
                play();
            }
        } elsif ($choice eq "4") {
            print("\nQuitting game...\n");
            print("Thanks for playing!\n\n");
            last;
        } else {
            clear();
            print("\nInvalid choice. Please enter a number between 1 and 4.\n\n");
        }
    }
}

sub clear {
    system("clear");
}

menu();
