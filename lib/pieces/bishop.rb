# frozen_string_literal: true

require_relative '../piece'
require_relative '../movements/bishop_movement'
require_relative 'king'

# Chess piece: The Bishop
class Bishop < Piece
  include BishopMovement

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
    [method(:up_rightward),
     method(:up_leftward),
     method(:down_rightward),
     method(:down_leftward)]
  end
end
