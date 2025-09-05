# frozen_string_literal: true

require_relative 'piece'
require_relative '../movements/king_movement'

# Chess piece: The King
class King < Piece
  include KingMovement

  def search_legal_moves(board)
    moves.select { |square| opponent_in_square?(square, board) || empty_square?(square, board) }
  end
end
