# frozen_string_literal: true

# Forsyth–Edwards Notation (FEN) of a chess game
module FEN
  def record_fen(chessboard, chosen_piece = nil)
    record = []

    fen_board = fen_chessboard(chessboard)

    8.downto(1) do |i|
      fen_board[i.to_s].each { |piece| record << piece }
      record << '/' unless i == 1 # Last row
    end

    record << " #{fen_player_turn(chosen_piece)}"

    record << " #{fen_castling_availability(chessboard)}"

    record << " #{en_passant_target_square(chosen_piece)}"

    record << " #{halfmove_clock}"

    record << " #{fullmove_number}"

    record.join
  end

  private

  def fen_chessboard(chessboard)
    fen_board = outline_fen_board
    empty_squares = []
    column = 0

    chessboard.each do |square, piece|
      row = square[1]
      column += 1

      if piece.is_a?(Piece)
        fen_board[row] << sum_empty_squares(empty_squares)
        empty_squares = []

        fen_board[row] << fen_piece(piece)
      else # It's an empty square
        empty_squares << piece
      end

      next unless column == 8 # Last column

      fen_board[row] << sum_empty_squares(empty_squares)
      fen_board[row].compact!
      empty_squares = []
      column = 0
    end

    fen_board
  end

  def fen_player_turn(chosen_piece)
    return 'w' if chosen_piece.nil?

    chosen_piece.color == 'white' ? 'b' : 'w'
  end

  def fen_castling_availability(chessboard)
    availability = []

    availability << 'K' if right_to_castle?('white', 'kingside', chessboard)
    availability << 'Q' if right_to_castle?('white', 'queenside', chessboard)

    availability << 'k' if right_to_castle?('black', 'kingside', chessboard)
    availability << 'q' if right_to_castle?('black', 'queenside', chessboard)

    availability.empty? ? '-' : availability.join
  end

  def right_to_castle?(king_color, rook_side, chessboard)
    king = search_king(king_color, chessboard)
    rook = search_rook_to_castle(king_color, rook_side, chessboard)

    return unless king.is_a?(King)
    return unless rook.is_a?(Rook)
    return unless king.color == rook.color
    return unless king.moves_log.one?
    return unless rook.moves_log.one?
    return unless king.current_square[1] == rook.current_square[1]

    true
  end

  def en_passant_target_square(chosen_piece)
    return '-' unless double_stepped?(chosen_piece)

    square = chosen_piece.current_square

    column = square[0]

    row = chosen_piece.color == 'white' ? prev(square[1]) : square[1].next

    column + row
  end

  def fen_piece(piece)
    return piece unless piece.is_a?(Piece) # Returns empty square

    if piece.is_a?(Knight)
      piece.color == 'white' ? piece.class.to_s[1].upcase : piece.class.to_s[1]
    else
      piece.color == 'white' ? piece.class.to_s[0] : piece.class.to_s[0].downcase
    end
  end

  def sum_empty_squares(array)
    return if array.empty?

    array.count.to_s
  end

  def outline_fen_board
    board = {}

    '1'.upto('8') do |row|
      board[row] = []
    end

    board
  end

  def search_king(color, chessboard)
    chessboard.select do |_square, piece|
      piece.is_a?(King) && piece.color == color
    end.values[0]
  end

  def search_rook_to_castle(king_color, side, chessboard)
    rooks_sides = { 'kingside' => { 'white' => 'h1', 'black' => 'h8' },
                    'queenside' => { 'white' => 'a1', 'black' => 'a8' } }

    chessboard.select do |_square, piece|
      piece.is_a?(Rook) &&
        piece.color == king_color &&
        piece.moves_log.first == rooks_sides[side][king_color]
    end.values[0]
  end

  def double_stepped?(pawn)
    return false unless pawn.is_a?(Pawn)
    return false unless pawn.player.last_touched_piece?(pawn)

    pawn.moves_log.size == 2 &&
      pawn.current_square.match?(en_passant_pattern(pawn.color))
  end

  def en_passant_pattern(color)
    color == 'white' ? /^[a-h]4$/ : /^[a-h]5$/
  end

  def prev(string)
    (string.to_i(36) - 1).to_s(36)
  end
end
