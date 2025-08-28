# frozen_string_literal: true

# Chess Pieces
class Piece
  EMPTY_SQUARE = ' '

  attr_reader :color, :current_square, :moves, :legal_moves, :moves_log, :player

  def initialize(color, square)
    @color = color
    @current_square = square
    @moves = nil
    @legal_moves = nil
    @moves_log = [@current_square]
    @player = nil
  end

  def opponent_in_square?(square, board)
    return false unless board.key?(square)
    return false if empty_square?(square, board)

    board[square].color != color
  end

  def empty_square?(square, board)
    board[square] == EMPTY_SQUARE
  end
end
