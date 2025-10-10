# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'

# Chess Game
class Game
  attr_reader :board, :white_player, :black_player, :player_in_turn

  def initialize
    @board = Board.new
    @white_player = Player.new('white', @board)
    @black_player = Player.new('black', @board)
    @player_in_turn = @white_player
    @winner = nil
    @stalemate = false
    @draw = false
  end

  def player_turns
    loop do
      moveable_pieces = search_moveable_pieces

      break if moveable_pieces.none?

      chosen_piece = select_piece_to_move(moveable_pieces)

      move_to_square = select_square_to_move(chosen_piece)

      player_in_turn.move!(move_to_square, chosen_piece)

      switch_player_turn
    end
  end

  def set_pieces
    set_white_pieces
    set_black_pieces
  end

  def set_up_pieces_movements
    PawnMovement.set_up
    RookMovement.set_up
    KnightMovement.set_up
    BishopMovement.set_up
    QueenMovement.set_up
    KingMovement.set_up
  end

  private

  def switch_player_turn
    @player_in_turn = @player_in_turn == @white_player ? @black_player : @white_player
  end

  def search_moveable_pieces
    moveable_pieces = []

    player_in_turn.pieces.each do |piece|
      legal_moves = piece.search_legal_moves(board.chessboard)

      piece.legal_moves = piece.screen_legal_moves(legal_moves, board.chessboard)

      moveable_pieces << piece if piece.legal_moves.any?
    end

    moveable_pieces
  end

  def select_piece_to_move(moveable_pieces)
    pieces_square = moveable_pieces.map(&:current_square)

    square_options = Regexp.union(pieces_square)

    piece_at = player_in_turn.player_input(square_options)

    moveable_pieces.select { |piece| piece.current_square == piece_at }[0]
  end

  def select_square_to_move(piece)
    legal_moves_options = Regexp.union(piece.legal_moves)

    player_in_turn.player_input(legal_moves_options)
  end

  def set_white_pieces
    color = 'white'
    positions = { Pawn: %w[a2 b2 c2 d2 e2 f2 g2 h2],
                  Rook: %w[a1 h1],
                  Knight: %w[b1 g1],
                  Bishop: %w[c1 f1],
                  Queen: %w[d1],
                  King: %w[e1] }

    positions.each do |piece, squares|
      squares.each do |square|
        board.chessboard[square] = create_piece(piece, color, square, white_player)
      end
    end
  end

  def set_black_pieces
    color = 'black'
    positions = { Pawn: %w[a7 b7 c7 d7 e7 f7 g7 h7],
                  Rook: %w[a8 h8],
                  Knight: %w[b8 g8],
                  Bishop: %w[c8 f8],
                  Queen: %w[d8],
                  King: %w[e8] }

    positions.each do |piece, squares|
      squares.each do |square|
        board.chessboard[square] = create_piece(piece, color, square, black_player)
      end
    end
  end

  def create_piece(piece, color, square, player)
    Object.const_get(piece).new(color, square, player)
  end
end
