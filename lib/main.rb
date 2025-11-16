# frozen_string_literal: true

require_relative '../lib/game'

# Play Chess Game
def play_game
  chess = Game.new
  chess.play
end

play_game
