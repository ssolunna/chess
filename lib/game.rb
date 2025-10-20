# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'

require 'json'

# Chess Game
class Game
  attr_reader :board, :white_player, :black_player,
              :player_in_turn, :winner, :stalemate, :draw

  FILENAME = 'saved_game.json'

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
    load_game if File.exist?(FILENAME)

    loop do
      moveable_pieces = search_moveable_pieces

      break if moveable_pieces.none?

      chosen_piece = select_piece_to_move(moveable_pieces)

      return save_game if chosen_piece == 'save'

      move_to_square = select_square_to_move(chosen_piece)

      player_in_turn.move!(chosen_piece, move_to_square)

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

  def save_game
    File.open(FILENAME, 'w') do |file|
      JSON.dump(serialize_game, file)
    end
  end

  def load_game
    saved_game = JSON.parse(File.read(FILENAME))

    deserialize_game(saved_game)

    File.delete(FILENAME)
  end

  def deserialize_game(data)
    deserialize_board(data['board'])
    deserialize_player(@white_player, data['white_player'])
    deserialize_player(@black_player, data['black_player'])

    @player_in_turn = data['player_in_turn'] == 'white' ? @white_player : @black_player
  end

  def deserialize_board(data)
    @board.chessboard.each do |square, empty|
      @board.chessboard[square] = data[square].is_a?(String) ? empty : deserialize_piece(data[square])
    end
  end

  def deserialize_piece(data)
    player = data['color'] == 'white' ? @white_player : @black_player

    piece = create_piece(data['name'], data['color'], data['current_square'], player)

    piece.legal_moves = data['legal_moves']

    piece.moves_log.shift
    piece.moves_log.push(*data['moves_log'])

    piece
  end

  def deserialize_player(player, data)
    data['pieces_moved_log'].each do |data_piece_moved|
      active_piece = player.pieces.select do |piece|
        piece.moves_log == data_piece_moved['moves_log']
      end[0]

      player.pieces_moved_log <<
        if active_piece.nil?
          deserialize_piece(data_piece_moved)
        else
          active_piece
        end
    end
  end

  def serialize_game
    {
      board: serialize_board(@board.chessboard),
      white_player: serialize_player(@white_player),
      black_player: serialize_player(@black_player),
      player_in_turn: @player_in_turn.color
    }
  end

  def serialize_board(chessboard)
    serialized_board = chessboard.dup

    serialized_board.each do |square, value|
      serialized_board[square] = value.is_a?(String) ? value : serialize_piece(value)
    end

    serialized_board
  end

  def serialize_piece(piece)
    {
      name: piece.class.to_s,
      color: piece.color,
      current_square: piece.current_square,
      legal_moves: piece.legal_moves,
      moves_log: piece.moves_log
    }
  end

  def serialize_player(player)
    {
      pieces_moved_log: player.pieces_moved_log.map { |piece| serialize_piece(piece) }
    }
  end

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

    choice = player_in_turn.player_input(pieces_square, 'save')

    return choice if choice == 'save'

    moveable_pieces.select { |piece| piece.current_square == choice }[0]
  end

  def select_square_to_move(piece)
    player_in_turn.player_input(piece.legal_moves)
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

  def create_piece(piece, color, square, player = nil)
    Object.const_get(piece).new(color, square, player)
  end
end
