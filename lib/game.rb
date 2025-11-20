# frozen_string_literal: true

require_relative '../lib/serialization'
require_relative '../lib/fen'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/rook'
require_relative './pieces/bishop'
require_relative './pieces/knight'
require_relative './pieces/pawn'

require 'json'

# Chess Game
class Game
  include Display
  include Serialize
  include FEN

  attr_reader :board, :white_player, :black_player,
              :player_in_turn, :winner, :stalemate, :draw,
              :resign, :draw_agreed, :fen_log,
              :halfmove_clock, :fullmove_number

  FILENAME = 'saved_game.json'

  def initialize
    @board = Board.new
    @white_player = Player.new('white', @board)
    @black_player = Player.new('black', @board)
    @player_in_turn = @white_player
    @winner = nil
    @stalemate = false
    @resign = false
    @draw_agreed = false
    @fen_log = []
    @halfmove_clock = 0
    @fullmove_number = 1
  end

  def play
    set_up_pieces_movements

    if File.exist?(FILENAME) && load_saved_game?
      load_game
    else
      set_pieces
      save_fen_record
    end

    player_turns
  end

  private

  def player_turns
    until halfmove_clock == 100 || threefold_repetition?
      board.display

      moveable_pieces = search_moveable_pieces

      return set_winner if moveable_pieces.none?

      choice = select_piece_to_move(moveable_pieces)

      return end_game(choice) if default_options.include?(choice)

      move_to_square = select_square_to_move(choice)

      place_movement(choice, move_to_square)

      return if draw_proposal && draw_agreed

      switch_player_turn
    end

    end_game('draw')
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

    display_prompt_piece(player_in_turn.color)

    choice = player_in_turn.player_input(pieces_square, default_options)

    return choice if default_options.include?(choice)

    touched_piece = moveable_pieces.select { |piece| piece.current_square == choice }[0]

    touched_piece.touched = true

    touched_piece
  end

  def select_square_to_move(piece)
    board.display

    display_prompt_move(player_in_turn.color, piece)

    piece.touched = false

    player_in_turn.player_input(piece.legal_moves)
  end

  def place_movement(chosen_piece, move_to_square)
    piece_at_moved_square = board.chessboard[move_to_square]

    player_in_turn.move!(chosen_piece, move_to_square)

    remove_player_piece(piece_at_moved_square) if piece_at_moved_square.is_a?(Piece)

    promote(chosen_piece) if promoteable?(chosen_piece)

    save_fen_record(chosen_piece, piece_at_moved_square)

    board.display
  end

  def promoteable?(pawn)
    return unless pawn.is_a?(Pawn)

    last_row_pattern = { 'white' => /^[a-h]8$/, 'black' => /^[a-h]1$/ }

    pawn.current_square.match?(last_row_pattern[pawn.color])
  end

  def promote(pawn)
    board.display

    puts "          \e[93;1m\u276A Pawn Promotion \u276B\e[0m"
    print "\e[1m[#{player_in_turn.color.capitalize}]\e[0m "
    print 'Type name of piece to promote Pawn to: '

    pieces_options = %w[queen rook bishop knight]

    chosen_piece = player_in_turn.player_input(pieces_options)

    new_piece = create_piece(chosen_piece.capitalize, pawn.color, pawn.current_square)

    remove_player_piece(pawn)

    board.chessboard[pawn.current_square] = new_piece
  end

  def save_fen_record(chosen_piece = nil, piece_at_moved_square = nil)
    update_halfmove_clock(chosen_piece, piece_at_moved_square)

    @fullmove_number += 1 if @player_in_turn == @black_player

    @fen_log << record_fen(board.chessboard, chosen_piece)
  end

  def draw_proposal
    puts "          \e[93;1m\u276A Draw proposal \u276B\e[0m"
    print "\e[1m[#{player_in_turn.color.capitalize}]\e[0m "
    print 'Want to propose a draw? [y|n]: '

    player_in_turn_input = gets.chomp.downcase

    return false unless player_in_turn_input.match?(/^(y|draw|yes)$/)

    print "\e[1m[#{select_opponent.color.capitalize}]\e[0m "
    print 'Accept draw proposal? [y|n]: '

    opponent_player_input = gets.chomp.downcase

    return false unless opponent_player_input.match?(/^(y|draw|yes)$/)

    @draw_agreed = true
  end

  def update_halfmove_clock(chosen_piece, piece_at_moved_square)
    return if chosen_piece.nil? || piece_at_moved_square.nil?

    if chosen_piece.is_a?(Pawn) || piece_at_moved_square.is_a?(Piece)
      @halfmove_clock = 0

      return
    end

    @halfmove_clock += 1
  end

  def threefold_repetition?
    move_records = fen_log.dup.reverse

    i = 0
    move = trim_clocks(move_records[i])
    previous_same_move = trim_clocks(move_records[i + 4])

    count = 1
    while move == previous_same_move
      i += 4
      count += 1

      return true if count == 3

      move = previous_same_move
      previous_same_move = trim_clocks(move_records[i + 4])
    end

    false
  end

  def trim_clocks(fen_record)
    return if fen_record.nil?

    record_reversed = fen_record.reverse

    record_reversed.each_char do |c|
      next unless c.match?(/[a-z]|-/)

      index = record_reversed.index(c) - 1

      return record_reversed.reverse[0, record_reversed.size - index]
      break
    end
  end

  def save_game
    File.open(FILENAME, 'w') do |file|
      JSON.dump(serialize_game, file)
    end

    puts
    puts 'Game saved.', 'Exiting...'
  end

  def load_game
    saved_game = JSON.parse(File.read(FILENAME))

    deserialize_game(saved_game)

    puts 'Game loaded.', 'Deleting saved game...'

    File.delete(FILENAME)
  end

  def load_saved_game?
    print 'Saved game found. Do you want to load it? [y|n]: '
    response = gets.chomp.downcase
    puts

    response.match?(/^(y|yes)$/)
  end

  def end_game(choice)
    case choice
    when 'save' then save_game
    when 'resign' then resign_game
    when 'draw' then draw_game
    end
  end

  def set_pieces
    positions = { Pawn:
                    { white: %w[a2 b2 c2 d2 e2 f2 g2 h2],
                      black: %w[a7 b7 c7 d7 e7 f7 g7 h7] },
                  Rook:
                    { white: %w[a1 h1],
                      black: %w[a8 h8] },
                  Knight:
                    { white: %w[b1 g1],
                      black: %w[b8 g8] },
                  Bishop:
                    { white: %w[c1 f1],
                      black: %w[c8 f8] },
                  Queen:
                    { white: %w[d1],
                      black: %w[d8] },
                  King:
                    { white: %w[e1],
                      black: %w[e8] } }

    positions.each do |piece, position|
      position.each do |color, squares|
        squares.each do |square|
          board.chessboard[square] = create_piece(piece, color.to_s, square)
        end
      end
    end
  end

  def set_up_pieces_movements
    PawnMovement.set_up
    RookMovement.set_up
    KnightMovement.set_up
    BishopMovement.set_up
    QueenMovement.set_up
    KingMovement.set_up
  end

  def switch_player_turn
    @player_in_turn = select_opponent
  end

  def set_winner
    if @resign == true || mated?
      @winner = select_opponent
    else
      @stalemate = true
    end
  end

  def mated?
    select_opponent.pieces.select { |piece| piece.gives_check?(board.chessboard) }.any?
  end

  def resign_game
    @resign = true

    set_winner
  end

  def draw_game
    @halfmove_clock == 100 ? 'Draw by 50 moves rule' : 'Draw by repetition of moves rule'
  end

  def select_opponent
    @player_in_turn == white_player ? black_player : white_player
  end

  def default_options
    %w[save resign]
  end

  def create_piece(piece, color, square)
    player = color == 'white' ? @white_player : @black_player

    Object.const_get(piece).new(color, square, player)
  end

  def remove_player_piece(piece)
    piece.player.pieces.delete(piece)
  end
end
