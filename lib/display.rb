# frozen_string_literal: true

module Display
  def display_intro
    printf "\033[H\033[2J" # Clears screen
    puts chess_ascii_art
    puts <<~HEREDOC

\e[1mGame\e[0m: \e[1;33mCHESS\e[0m \e[2m(Classic)\e[0m
\e[1mDescription\e[0m: This game is intended to be played by two players
             One plays with the white pieces, and the other
             plays with the black pieces. White starts!
\e[1mRules\e[0m: The game covers pretty much all the rules of a classic
       game of chess, except for the time clock. For further
       information look on the following website:
       \e[2mhttps://www.chessvariants.org/d.chess/chess.html\e[0m
\e[1mGuidelines\e[0m: • Notation for squares is \e[1m[column][row]\e[0m, e.g. "e1"
            • To save the game, type \e[1msave\e[0m when prompted to
              choose a piece
            • To resign, type \e[1mresign\e[0m when prompted to choose
              a piece
            • If you \e[1mare not sure\e[0m what to type, \e[1mpress enter\e[0m
              and a range of options will be displayed

    HEREDOC
  end

  def display_prompt_piece(player_color)
    display_player_turn(player_color)
    print "Type square of \e[1mpiece\e[0m to move: "
  end

  def display_prompt_move(player_color, piece)
    display_player_turn(player_color)
    print "Type square to \e[1mmove\e[0m \e[93m#{piece.class.name} at #{piece.current_square}\e[0m: "
  end

  def display_invalid_input(options)
    print "\e[1;31m[Invalid input]\e[0m "
    puts "\e[92mAvailable options: #{options.join(' | ')}\e[0m"
    print 'Try again: '
  end

  def display_check(piece)
    print "\e[1;31m\u276A \e[0m"
    print "\e[1;31mCHECK WARNING\e[0m"
    print " \e[1;31m\u276B \e[0m"
    print "King in \e[1mcheck by #{piece.color.capitalize}\e[0m \e[93m#{piece.class.name} at #{piece.current_square}\e[0m"
    puts
  end

  def display_winner(player)
    print "\e[1;32m\u276A \e[0m"
    print "\e[1;32mCHECKMATE\e[0m"
    print " \e[1;32m\u276B \e[0m"
    print "#{player.color.capitalize} \e[1mwins\e[0m !"
    puts
  end

  def display_stalemate(player)
    print "\e[1;93m\u276A \e[0m"
    print "\e[1;93mSTALEMATE\e[0m"
    print " \e[1;93m\u276B \e[0m"
    print "\e[1m#{player.color.capitalize}\e[0m cannot make any legal move"
    puts
    puts "              The game is a \e[1mdraw\e[0m !"
  end

  def display_resignation(player)
    print "\e[1;32m\u276A \e[0m"
    print "\e[1;32m#{player.color.upcase} RESIGNS\e[0m"
    print " \e[1;32m\u276B \e[0m"
    print "#{select_opponent.color.capitalize} \e[1mwins\e[0m !"
    puts
  end

  def display_draw_50
    print "\e[1;33m\u276A \e[0m"
    print "\e[1;33m50 MOVES RULE\e[0m"
    print " \e[1;33m\u276B \e[0m"
    print "\e[1mDraw\e[0m claimed automatically"
    puts
    puts 'Ending game...'
  end

  def display_draw_threefold
    print "\e[1;33m\u276A \e[0m"
    print "\e[1;33mTHREEFOLD REPETITION\e[0m"
    print " \e[1;33m\u276B \e[0m"
    print "\e[1mDraw\e[0m claimed automatically"
    puts
    puts 'Ending game...'
  end

  private

  def chess_ascii_art
    filename = './media/chess_ascii.txt'

    begin
      File.read(filename)
    rescue Errno::ENOENT
      "\e[2m[Ascii art of chess pieces missing]\e[0m"
    end
  end

  def display_player_turn(player_color)
    print "\e[1m\u276A \e[0m"
    print "\e[1m#{token(player_color)}\e[0m"
    print " \e[1m\u276B \e[0m"
    puts "\e[1m#{player_color.capitalize}'s turn \e[0m"
  end

  def token(player_color)
    player_color == 'white' ? "\e[39m\u25CF" : "\e[30m\u25CF"
  end
end
