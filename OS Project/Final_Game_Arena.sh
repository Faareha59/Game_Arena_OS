#!/bin/bash

# Color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

# Start message
# Start message
start_message() {
    clear
    echo -e "\n${CYAN}=========================================${NC}"
    echo -e "${PURPLE}      WELCOME TO THE GAME ARENA  ${NC} ${NC}"
    echo -e "${CYAN}=========================================${NC}\n"
    echo -e "${GREEN}Select a game from the menu below and enjoy!${NC}\n"
}


# Display Main Menu
display_menu() {
    echo -e "\nChoose a game to play:"
    echo -e "${RED}1) Hangman${NC}"
    echo -e "${BLUE}2) Snake${NC}"
    echo -e "${YELLOW}3) Rock, Paper, Scissors${NC}"
    echo -e "${CYAN}4) Word Scramble${NC}"
    echo -e "${GREEN}5) Typing Speed Test${NC}"
    echo -e "${PURPLE}6) Guess the Country ${NC}"
    echo -e "${RED}7) Exit${NC}\n"
}

# Main Menu Loop
main_menu() {
    start_message
    while true; do
        display_menu
        read -p "Choose an option (1-7): " option

        case $option in
            1) hangman_game ;;
            2) play_snake_game ;;
            3) rock_paper_scissors_game ;;
            4) word_scramble_game ;;
            5) typing_speed_test ;;
            6) guess_country_game ;;
            7) echo -e "${RED}Exiting the Game Arena. Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
        esac
    done
}

# Sample placeholder function for Guess the Country
guess_country_game() {
    echo -e "${PURPLE}=== Guess the Country Game ===${NC}"
    countries=("Japan" "Egypt" "Canada" "Brazil" "Australia")
    hints=("Land of the Rising Sun" "Home of the Pyramids" "Known for maple syrup" "Famous for the Amazon Rainforest" "Known for kangaroos and the Outback")
    options=(
        "Japan China Korea Thailand"
        "Egypt Morocco Nigeria Kenya"
        "Canada USA Mexico Germany"
        "Brazil Argentina Peru Colombia"
        "Australia New Zealand Fiji Papua"
    )
    score=0

    for i in "${!countries[@]}"; do
        echo -e "${CYAN}Hint: ${hints[$i]}${NC}"
        echo -e "${YELLOW}Options: ${options[$i]}${NC}"
        echo -e "${BLUE}You have 10 seconds to answer!${NC}"

        # Timer implementation
        read -t 10 -p "Your choice: " answer

        if [[ $? -ne 0 ]]; then
            echo -e "${RED}\nTime's up! The correct answer was: ${countries[$i]}${NC}"
        elif [[ "$answer" == "${countries[$i]}" ]]; then
            echo -e "${GREEN}Correct!${NC}"
            score=$((score + 1))
        else
            echo -e "${RED}Incorrect! The correct answer was: ${countries[$i]}${NC}"
        fi
        echo
    done

    echo -e "${PURPLE}Game Over! Your final score: $score${NC}\n"
    read -p "Press Enter to return to the main menu."
}
# --- Rock, Paper, Scissors Function ---
rock_paper_scissors_game() {
    echo "Welcome to Rock, Paper, Scissors!"
    choices=("Rock" "Paper" "Scissors")
    computer_choice=$((RANDOM % 3))

    echo "Enter your choice (Rock, Paper, Scissors):"
    read user_choice

    if [[ ! " ${choices[@]} " =~ " ${user_choice} " ]]; then
        echo "Invalid choice! Please choose Rock, Paper, or Scissors."
        return
    fi

    echo "Computer chose: ${choices[$computer_choice]}"

    if [[ "$user_choice" == "${choices[$computer_choice]}" ]]; then
        echo "It's a tie!"
    elif [[ "$user_choice" == "Rock" && "${choices[$computer_choice]}" == "Scissors" ]] ||
         [[ "$user_choice" == "Scissors" && "${choices[$computer_choice]}" == "Paper" ]] ||
         [[ "$user_choice" == "Paper" && "${choices[$computer_choice]}" == "Rock" ]]; then
        echo "You win!"
    else
        echo "You lose!"
    fi
    read -p "Press Enter to return to the main menu."
}
# --- Word Scramble Function ---
# --- Word Scramble Function ---
word_scramble_game() {
    # Define a list of words for the game
    words=("linux" "bash" "script" "terminal" "command" "shell" "kernel")

    while true; do
        # Pick a random word from the list
        word="${words[$((RANDOM % ${#words[@]}))]}"

        # Scramble the word
        scrambled=$(echo $word | fold -w1 | shuf | tr -d '\n')

        echo "Unscramble this word: $scrambled"
        read -p "Your guess: " guess

        if [[ "$guess" == "$word" ]]; then
            echo "Correct! You guessed the word."
        else
            echo "Incorrect! The correct word was $word."
        fi

        # Ask user if they want to play again
        read -p "Do you want to play again? (y/n): " play_again
        if [[ $play_again != "y" ]]; then
            echo "Thank you for playing Word Scramble!"
            break
        fi
    done
}





# --- Hangman Game Function with Full Stickman ---
hangman_game() {
    # Define word list and corresponding hints
    words=("shell" "script" "linux" "terminal" "command")
    hints=("A command-line interpreter in Linux systems."
           "A sequence of commands saved in a file."
           "An open-source operating system kernel."
           "A place to interact with the OS in text form."
           "An instruction to the OS to perform a task.")

    used_indices=()  # Track used words

    # Define stages of the stickman figure
    stickman_stages=(
        "

        "
        "

        O
        "
        "

        O
        |
        "
        "

        O
       /|
        "
        "


        O
       /|\\
        "
        "


        O
       /|\\
       /
        "
        "


        O
       /|\\
       / \\
          "
    )

    while true; do
        # Select a random unused word
        while true; do
            index=$((RANDOM % ${#words[@]}))
            if [[ ! " ${used_indices[@]} " =~ " $index " ]]; then
                used_indices+=("$index")
                break
            fi
        done

        # Reset used words list if all words have been used
        if [[ ${#used_indices[@]} -eq ${#words[@]} ]]; then
            used_indices=()
        fi

        word="${words[$index]}"
        hint="${hints[$index]}"
        guessed=""
        tries=6
        display_word=$(echo "$word" | sed 's/./_/g')

        echo "Welcome to Hangman! The word has ${#word} letters."
        echo "Hint: $hint"
        while true; do
            echo "Word: $display_word"
            echo "Guessed letters: $guessed"
            echo "Tries left: $tries"
            echo -e "${stickman_stages[6 - $tries]}"

            read -p "Enter a letter: " guess

            if [[ ${#guess} -ne 1 ]]; then
                echo "Please enter one letter at a time."
                continue
            fi

            if [[ $guessed =~ $guess ]]; then
                echo "You already guessed '$guess'. Try a different letter."
                continue
            fi

            guessed="$guessed$guess"
            if [[ $word =~ $guess ]]; then
                display_word=$(echo "$word" | sed "s/[^$guessed]/_/g")
            else
                tries=$((tries-1))
            fi

            if [[ "$display_word" == "$word" ]]; then
                echo "Congratulations! You've guessed the word: $word"
                break
            fi

            if [[ $tries -eq 0 ]]; then
                echo "Game over! The word was: $word"
                echo -e "${stickman_stages[6]}"
                break
            fi
        done

        # Ask user if they want to play again
        read -p "Do you want to play again? (y/n): " play_again
        if [[ $play_again != "y" ]]; then
            echo "Thank you for playing Hangman!"
            break
        fi
    done
}

# --- Typing Speed Test Function ---
get_time() {
    start_time=$(date +%s)
    read -p "$1" user_input
    end_time=$(date +%s)
    time_taken=$((end_time - start_time))
}

typing_speed_test() {
    echo "Welcome to the Typing Speed Test!"
    echo "You will be given a sentence to type. Try to type it as fast as possible."
    echo -e "\nPress Enter to begin..."

    # Wait for user to press Enter to start
    read

    # The sentence to type
    sentence="The quick brown fox jumps over the lazy dog."

    # Show the sentence to the player
    echo -e "\nType the following sentence as fast as you can:"
    echo "$sentence"
    echo -e "\nWhen you're ready, press Enter to start typing..."

    # Wait for the player to press Enter to start typing
    read

    # Get the typing time and input
    echo "Start typing now!"
    get_time "$sentence"

    # Check if the user typed the sentence correctly
    if [[ "$user_input" == "$sentence" ]]; then
        echo -e "\nGreat! You typed the sentence correctly."
    else
        echo -e "\nOops! There were some mistakes. Try again!"
    fi

    # Display the time taken
    echo -e "\nTime taken: $time_taken seconds"

    # Calculate typing speed (words per minute)
    words=$(echo "$sentence" | wc -w)
    wpm=$((words * 60 / time_taken))

    echo -e "Your typing speed: $wpm words per minute."
    echo -e "\nPress Enter to return to the main menu."
    read
}


# --- Snake Game Function ---
play_snake_game() {
    board_width=20
    board_height=10
    snake_head_x=5
    snake_head_y=5
    direction="RIGHT"
    snake_body=("$snake_head_x,$snake_head_y")
    food_x=$((RANDOM % board_width))
    food_y=$((RANDOM % board_height))
    score=0

    draw_board() {
        clear
        echo "Score: $score"
        for ((y=0; y<board_height; y++)); do
            for ((x=0; x<board_width; x++)); do
                if [[ "$x,$y" == "$snake_head_x,$snake_head_y" ]]; then
                    echo -n "O"
                elif [[ " ${snake_body[@]} " =~ " $x,$y " ]]; then
                    echo -n "#"
                elif [[ "$x,$y" == "$food_x,$food_y" ]]; then
                    echo -n "@"
                else
                    echo -n "."
                fi
            done
            echo
        done
    }

    move_snake() {
        case $direction in
            "UP") snake_head_y=$((snake_head_y - 1)) ;;
            "DOWN") snake_head_y=$((snake_head_y + 1)) ;;
            "LEFT") snake_head_x=$((snake_head_x - 1)) ;;
            "RIGHT") snake_head_x=$((snake_head_x + 1)) ;;
        esac
    }

    check_collision() {
        if [[ "$snake_head_x" -lt 0 || "$snake_head_x" -ge $board_width || "$snake_head_y" -lt 0 || "$snake_head_y" -ge $board_height ]]; then
            echo "Game Over! You hit the wall."
            return 1
        fi
        for segment in "${snake_body[@]}"; do
            IFS=',' read -r segment_x segment_y <<< "$segment"
            if [[ "$segment_x" == "$snake_head_x" && "$segment_y" == "$snake_head_y" ]]; then
                echo "Game Over! You ran into your body."
                return 1
            fi
        done
        return 0
    }

    game_loop() {
        while true; do
            move_snake
            check_collision || break
            snake_body=("$snake_head_x,$snake_head_y" "${snake_body[@]:0:${#snake_body[@]}-1}")

            if [[ "$snake_head_x,$snake_head_y" == "$food_x,$food_y" ]]; then
                score=$((score + 1))
                snake_body+=("$food_x,$food_y")
                food_x=$((RANDOM % board_width))
                food_y=$((RANDOM % board_height))
            fi

            draw_board

            # Sleep and change direction
            read -t 0.1 -n 1 key
            case $key in
                w) direction="UP" ;;
                s) direction="DOWN" ;;
                a) direction="LEFT" ;;
                d) direction="RIGHT" ;;
                q) break ;;
            esac
        done
    }

    game_loop
    echo "Press Enter to return to the main menu."
    read
}

# Start the Game Arena
main_menu

