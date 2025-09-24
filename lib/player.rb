# frozen_string_literal: true

require_relative './movements/chessboard_directions'
require_relative './pieces/pawn'
require_relative './pieces/king'

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
    castling_move_rook(touched_piece, to_square, board) if castling?(touched_piece, to_square)

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

  def taking_en_passant?(pawn, to_square, board)
    return unless pawn.is_a?(Pawn)

    empty_square?(to_square, board) && diagonal_move?(pawn, to_square)
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

  def castling_move_rook(king, king_to_square, board)
    rook = find_rook_to_castle(king, king_to_square, board)

    direction = case king_to_square
                in 'g8' | 'g1' then method(:rightward)
                in 'c8' | 'c1' then method(:leftward)
                end

    direction.call(king.current_square) do |next_square|
      move!(next_square, rook, board)

      break
    end
  end

  def castling?(king, to_square)
    return unless king.is_a?(King)

    [method(:leftward), method(:rightward)].each do |direction|
      steps = 0

      direction.call(king.current_square) do |next_square|
        steps += 1

        next unless steps == 2

        return true if next_square == to_square

        break
      end
    end

    false
  end

  def find_rook_to_castle(king, king_to_square, board)
    rooks = find_rooks(king, board)

    return rooks[0] if rooks.size == 1

    [method(:leftward), method(:rightward)].each do |direction|
      direction.call(king_to_square) do |next_square|
        break if king.current_square == next_square

        rook_to_castle = rooks.select { |rook| rook.current_square == next_square }

        return rook_to_castle[0] if rook_to_castle
      end
    end
  end

  def find_rooks(king, board)
    board.select do |_square, piece|
      piece.is_a?(Rook) &&
        piece.color == king.color
    end.values
  end

  def empty_square?(square, board)
    board[square] == EMPTY_SQUARE
  end
end
