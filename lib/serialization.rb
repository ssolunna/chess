# frozen_string_literal: true

# Serialize chessboard
module Serialize
  def serialize_game
    {
      board: serialize_chessboard(board.chessboard),
      white_player: serialize_player(white_player),
      black_player: serialize_player(black_player),
      player_in_turn: player_in_turn.color,
      fen_log: fen_log,
      halfmove_clock: halfmove_clock,
      fullmove_number: fullmove_number
    }
  end

  def serialize_chessboard(chessboard)
    serialized_board = chessboard.dup

    serialized_board.each do |square, value|
      serialized_board[square] = value.is_a?(String) ? value : serialize_piece(value)
    end

    serialized_board
  end

  def serialize_piece(piece)
    return if piece.nil?

    {
      name: piece.class.to_s,
      color: piece.color,
      current_square: piece.current_square,
      legal_moves: piece.legal_moves,
      moves_log: piece.moves_log,
      touched: piece.touched
    }
  end

  def serialize_player(player)
    {
      last_touched_piece: serialize_piece(player.last_touched_piece)
    }
  end

  def deserialize_game(data)
    deserialize_board(data['board'])
    deserialize_player(white_player, data['white_player'])
    deserialize_player(black_player, data['black_player'])

    player = data['player_in_turn'] == 'white' ? white_player : black_player
    instance_variable_set(:@player_in_turn, player)

    instance_variable_set(:@fen_log, data['fen_log'])

    instance_variable_set(:@halfmove_clock, data['halfmove_clock'])
    instance_variable_set(:@fullmove_number, data['fullmove_number'])
  end

  def deserialize_board(data)
    board.chessboard.each do |square, empty_square|
      board.chessboard[square] =
        data[square].is_a?(String) ? empty_square : deserialize_piece(data[square])
    end
  end

  def deserialize_piece(data)
    piece = create_piece(data['name'], data['color'], data['current_square'])

    piece.touched = data['touched']
    piece.legal_moves = data['legal_moves']

    piece.moves_log.shift
    piece.moves_log.push(*data['moves_log'])

    piece
  end

  def deserialize_player(player, data)
    data_piece_moved = data['last_touched_piece']

    last_piece = if data_piece_moved.nil?
                   nil
                 else
                   player.pieces.select do |piece|
                     piece.moves_log == data_piece_moved['moves_log']
                   end[0]
                 end

    player.instance_variable_set(:@last_touched_piece, last_piece)
  end
end
