# frozen_string_literal: true

require_relative './movements/chessboard_directions'
require_relative '../lib/display'
require_relative '../lib/game'

# Player of Chess
class Player
  include Display
  include Directions

  EMPTY_SQUARE = ' '

  attr_reader :color, :board, :pieces, :last_touched_piece

  def initialize(color, board)
    @color = color
    @board = board
    @pieces = []
    @last_touched_piece = nil
  end

  def player_input(*args)
    options = args.flatten.compact.uniq

    loop do
      user_input = gets.chomp.downcase

      return user_input if options.include?(user_input)

      display_invalid_input(options)
    end
  end

  def move!(touched_piece, to_square, board = @board.chessboard)
    take_en_passant(touched_piece, to_square, board) if taking_en_passant?(touched_piece, to_square, board)
    castling_move_rook(touched_piece, to_square, board) if castling?(touched_piece, to_square)

    board[to_square] = touched_piece
    board[touched_piece.current_square] = EMPTY_SQUARE
    touched_piece.current_square = to_square

    log_moves(touched_piece, to_square)
  end

  def last_touched_piece?(piece)
    last_touched_piece == piece
  end

  private

  def take_en_passant(pawn, to_square, board)
    direction = { 'white' => method(:downward), 'black' => method(:upward) }

    direction[pawn.color].call(to_square) do |square_taken|
      piece_taken = board[square_taken]

      piece_taken.player.pieces.delete(piece_taken)

      board[square_taken] = EMPTY_SQUARE

      break
    end
  end

  def taking_en_passant?(pawn, to_square, board)
    return unless pawn.is_a?(Pawn)
    return if board[to_square].is_a?(Piece)

    diagonal_move?(pawn, to_square)
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
      move!(rook, next_square, board)

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

  def log_moves(touched_piece, to_square)
    touched_piece.moves_log << to_square

    @last_touched_piece = touched_piece
  end
end
