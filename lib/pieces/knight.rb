# frozen_string_literal: true

require_relative '../piece'
require_relative '../movements/knight_movement'
require_relative 'king'

# Chess piece: The Knight
class Knight < Piece
  include KnightMovement

  def search_legal_moves(board)
    moves = moves_from(current_square)

    moves.select { |square| opponent_in_square?(square, board) || empty_square?(square, board) }
  end
end
