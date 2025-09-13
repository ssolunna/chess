# frozen_string_literal: true

require_relative 'piece'
require_relative 'king'
require_relative '../movements/knight_movement'

# Chess piece: The Knight
class Knight < Piece
  include KnightMovement

  def search_legal_moves(board)
    moves.select { |square| opponent_in_square?(square, board) || empty_square?(square, board) }
  end
end
