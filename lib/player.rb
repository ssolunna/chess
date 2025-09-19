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
    take_en_passant(touched_piece, to_square, board) if taking_en_passant?(touched_piece, to_square, board)

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

  def taking_en_passant?(piece, to_square, board)
    return unless piece.is_a?(Pawn)

    empty_square?(to_square, board) && diagonal_move?(piece, to_square)
  end

  def diagonal_move?(piece, to_square)
    directions = [method(:up_leftward),
                  method(:up_rightward),
                  method(:down_leftward),
                  method(:down_rightward)]

    directions.each do |direction|
      direction.call(piece.current_square) do |next_square|
        return true if next_square == to_square

        break
      end
    end

    false
  end

  def empty_square?(square, board)
    board[square] == EMPTY_SQUARE
  end
end
