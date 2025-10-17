# frozen_string_literal: true

# Chess Pieces
class Piece
  EMPTY_SQUARE = ' '

  attr_reader :color, :moves, :moves_log, :player

  attr_accessor :current_square, :legal_moves

  def initialize(color, square, player = nil)
    player.pieces << self unless player.nil?

    @color = color
    @current_square = square
    @legal_moves = nil
    @moves_log = [current_square]
    @player = player
  end

  # Select legal moves that do not put King in check after
  def screen_legal_moves(legal_moves, board)
    opponent_pieces = search_opponent_pieces(board)
    moves_to_remove = []

    legal_moves.each do |next_move|
      copied_board = board.dup
      copied_piece = dup

      copied_piece.player.move!(next_move, copied_piece, copied_board)

      opponent_pieces.each do |opponent_piece|
        moves_to_remove << next_move if opponent_piece.gives_check?(copied_board)
      end
    end

    legal_moves - moves_to_remove
  end

  def gives_check?(board)
    return false unless board.value?(self)
    return false unless find_opponent_king(board)

    search_legal_moves(board).include?(find_opponent_king(board).current_square)
  end

  def attacking_square?(square, board)
    return false unless board.value?(self)

    search_legal_moves(board).include?(square)
  end

  private

  def search_opponent_pieces(board)
    board.select do |_square, piece|
      piece != EMPTY_SQUARE &&
        piece.color != color
    end.values
  end

  def find_opponent_king(board)
    board.select do |_square, piece|
      piece.is_a?(King) &&
        piece.color != color
    end.values[0]
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
