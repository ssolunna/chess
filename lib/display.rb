# frozen_string_literal: true

module Display
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

  private

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
