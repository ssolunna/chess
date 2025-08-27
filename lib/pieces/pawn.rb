# frozen_string_literal: true

require_relative '../movements/pawn_movement'

# Chess piece: The Pawn
class Pawn
  include PawnMovement

  @@empty_square = ' '

  attr_reader :color, :current_square, :moves, :legal_moves, :moves_log, :player

  def initialize(color, square)
    @color = color
    @current_square = square
    @moves = nil
    @legal_moves = nil
    @moves_log = [@current_square]
    @player = nil
  end

  def search_legal_moves(board)
    [forward(board),
     two_squares_forward(board),
     taking(board),
     taking_en_passant(board)].flatten.compact
  end 

  private

  def forward(board)
    square_in_front = PawnMovement.in_front(@color, @current_square)

    square_in_front if board[square_in_front] == @@empty_square
  end

  def two_squares_forward(board)
    two_squares_in_front = PawnMovement.two_squares_in_front(@color, @current_square)

    two_squares_in_front if board[two_squares_in_front] == @@empty_square && forward(board)
  end

  def taking(board)
    moves = []

    square_on_right = PawnMovement.in_front('right', @color, @current_square)
    square_on_left = PawnMovement.in_front('left', @color, @current_square)

    moves.push(square_on_right) if opponent_in_square?(square_on_right, board)

    moves.push(square_on_left) if opponent_in_square?(square_on_left, board)

    moves
  end

  # Special movement
  def taking_en_passant(board)
    square_on_left = PawnMovement.left(@color, @current_square)
    square_on_right = PawnMovement.right(@color, @current_square)

    if double_stepped?(board[square_on_left])
      PawnMovement.en_passant(@color, square_on_left) 
    elsif double_stepped?(board[square_on_right])
      PawnMovement.en_passant(@color, square_on_right) 
    end
  end

  def opponent_in_square?(square, board)
    return if board[square] == @@empty_square || board[square].nil?

    board[square].color != @color
  end

  def double_stepped?(opponent_pawn)
    return false unless opponent_pawn.is_a?(Pawn) && opponent_pawn.color != @color && opponent_pawn.player.last_touched_piece?(opponent_pawn) 

    opponent_pawn.moves_log.size == 2 && opponent_pawn.current_square.match?(en_passant_pattern(opponent_pawn.color))
  end

  def en_passant_pattern(color)
    color == 'white' ? /^[a-h][4]$/ : /^[a-h][5]$/
  end
end
