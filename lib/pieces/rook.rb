# frozen_string_literal: true

require_relative 'piece'
require_relative 'king'
require_relative '../movements/rook_movement'

# Chess piece: The Rook
class Rook < Piece
  include RookMovement

  def search_legal_moves(board)
    legal_moves = []

    directions.each do |direction|
      direction.call(current_square) do |next_square|
        if opponent_in_square?(next_square, board)
          legal_moves << next_square
          break
        end

        break unless empty_square?(next_square, board)

        legal_moves << next_square
      end
    end

    legal_moves
  end

  private

  def directions
    [method(:upward),
     method(:downward),
     method(:rightward),
     method(:leftward)]
  end
end
