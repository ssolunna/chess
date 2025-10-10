# frozen_string_literal: true

require_relative './movements/chessboard_directions'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/rook'
require_relative './pieces/bishop'
require_relative './pieces/knight'
require_relative './pieces/pawn'

# Player of Chess
class Player
  include Directions

  EMPTY_SQUARE = ' '

  attr_reader :color, :board, :pieces, :pieces_moved_log

  def initialize(color, board)
    @color = color
    @board = board
    @pieces = []
    @touched_piece = nil
    @pieces_moved_log = []
  end

  def player_input(regex_pattern)
    loop do
      user_input = gets.chomp.downcase

      return user_input if user_input.match?(regex_pattern)
    end
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

  def promote(pawn)
    return unless pawn.is_a?(Pawn)
    return unless promoteable?(pawn)

    options_regex = /^(queen|rook|bishop|knight)$/

    chosen_piece = player_input(options_regex)

    new_piece = create_piece(chosen_piece.capitalize, pawn.current_square)

    board.chessboard[pawn.current_square] = new_piece
  end

  def promoteable?(pawn)
    return unless pawn.is_a?(Pawn)

    last_row_pattern = { 'white' => /^[a-h]8$/, 'black' => /^[a-h]1$/ }

    pawn.current_square.match?(last_row_pattern[pawn.color])
  end

  def last_touched_piece?(piece)
    pieces_moved_log.last == piece
  end

  private

  def create_piece(piece, square)
    Object.const_get(piece).new(color, square, self)
  end

  def take_en_passant(pawn, to_square, board)
    direction = { 'white' => method(:downward), 'black' => method(:upward) }

    direction[pawn.color].call(to_square) do |square_taken|
      board[square_taken] = EMPTY_SQUARE

      break
    end
  end

  def taking_en_passant?(pawn, to_square, board)
    return unless pawn.is_a?(Pawn)

    empty_square?(to_square, board) && diagonal_move?(pawn, to_square)
  end

  def diagonal_move?(pawn, to_square)
    directions = { 'white' => [method(:up_leftward), method(:up_rightward)],
                   'black' => [method(:down_leftward), method(:down_rightward)] }

    directions[pawn.color].each do |direction|
      direction.call(pawn.current_square) do |next_square|
        return true if next_square == to_square

        break
      end
    end

    false
  end

  def castling_move_rook(king, king_to_square, board)
    rook = find_rook_to_castle(king, king_to_square)

    direction = case king_to_square
                when 'g8', 'g1' then method(:rightward)
                when 'c8', 'c1' then method(:leftward)
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

  def find_rook_to_castle(king, king_to_square)
    rooks = pieces.select { |piece| piece.is_a?(Rook) }

    [method(:leftward), method(:rightward)].each do |direction|
      direction.call(king_to_square) do |next_square|
        break if king.current_square == next_square

        rook_to_castle = rooks.select { |rook| rook.current_square == next_square }

        return rook_to_castle[0] if rook_to_castle.any?
      end
    end
  end

  def empty_square?(square, board)
    board[square] == EMPTY_SQUARE
  end
end
