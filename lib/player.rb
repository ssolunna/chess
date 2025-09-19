# frozen_string_literal: true

require_relative './movements/chessboard_directions'
require_relative './pieces/pawn'

# Player of Chess
class Player
  include Directions

  EMPTY_SQUARE = ' '

  attr_reader :pieces_moved_log

  def initialize(color, board)
    @color = color
    @board = board
    @pieces = []
    @touched_piece = nil
    @pieces_moved_log = []
  end

  def move!(to_square, touched_piece = @touched_piece, board = @board.chessboard)
    take_en_passant(touched_piece, to_square, board) if touched_piece.is_a?(Pawn) &&
                                                        touched_piece.taking_en_passant?(to_square, board)

    board[to_square] = touched_piece
    board[touched_piece.current_square] = EMPTY_SQUARE

    touched_piece.current_square = to_square
    pieces_moved_log << touched_piece
    touched_piece.moves_log << to_square
  end

  def last_touched_piece?(piece)
    pieces_moved_log.last == piece
  end

  private

  def take_en_passant(pawn, to_square, board)
    if pawn.color == 'white'
      downward(to_square) do |square_down|
        board[square_down] = EMPTY_SQUARE
        break
      end
    else
      upward(to_square) do |square_up|
        board[square_up] = EMPTY_SQUARE
        break
      end
    end
  end
end
