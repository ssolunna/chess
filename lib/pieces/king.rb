# frozen_string_literal: true

require_relative 'piece'
require_relative '../movements/king_movement'

# Chess piece: The King
class King < Piece
  include KingMovement

  def search_legal_moves(board)
    [possible_moves(board), castling_moves(board)].flatten.compact
  end

  private

  def possible_moves(board)
    moves.select { |square| opponent_in_square?(square, board) || empty_square?(square, board) }
  end

  def castling_moves(board)
    return unless moves_log.size == 1 # King has not made a move yet

    rooks = player.pieces.select do |piece|
      piece.class.name == 'Rook' && piece.moves_log.size == 1
    end

    return unless rooks.any? # A Rook has not made a move yet

    possible_squares = []

    rooks.each { |rook| possible_squares << castling_square(rook, board) }

    possible_squares
  end

  # Search the square towards Rook that King can double step to
  def castling_square(rook, board)
    rook_on_left = rook.current_square == 'a8' || rook.current_square == 'a1' ? true : false

    direction = rook_on_left ? method(:leftward) : method(:rightward)

    return if pieces_in_between?(rook, direction, board)

    if rook_on_left
      square_moved_over = KingMovement.left(current_square)
      two_squares_towards_rook = KingMovement.left(square_moved_over)
    else
      square_moved_over = KingMovement.right(current_square)
      two_squares_towards_rook = KingMovement.right(square_moved_over)
    end

    return unless castling_squares_clear?(square_moved_over, two_squares_towards_rook, board)

    two_squares_towards_rook
  end

  def pieces_in_between?(rook, direction, board)
    direction.call(current_square) do |next_square|
      if empty_square?(next_square, board)
        next
      elsif next_square == rook.current_square
        return false
      else
        return true
      end
    end
  end

  def castling_squares_clear?(square_moved_over, two_squares_towards_rook, board)
    board.none? do |square, piece|
      next if piece == self || empty_square?(square, board) || piece.color == color

      piece.gives_check?(board) ||
        piece.attacking_square?(square_moved_over, board) ||
        piece.attacking_square?(two_squares_towards_rook, board)
    end
  end
end
