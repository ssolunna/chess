# frozen_string_literal: true

require_relative '../movements/chessboard_directions'

module PawnMovement
  extend Directions

  @@movements = nil

  WHITE_STARTING_ROW = %w[a2 b2 c2 d2 e2 f2 g2 h2].freeze
  BLACK_STARTING_ROW = %w[a7 b7 c7 d7 e7 f7 g7 h7].freeze

  def moves_from(color, square)
    @@movements[color][square]
  end

  def self.set_up
    @@movements = lay_out
  end

  private

  def self.lay_out(layout = { 'white' => {}, 'black' => {} }, color = 'white', queue = [*WHITE_STARTING_ROW])
    return layout if color == 'black' && queue.empty?

    if queue.empty?
      color = 'black'
      queue = [*BLACK_STARTING_ROW]
    end

    square = queue.first

    layout[color][square] = search_moves(color, square)

    layout[color][square].each do |move|
      next if layout[color].key?(move)

      queue.push(move) unless queue.include?(move)
    end

    queue.shift

    lay_out(layout, color, queue)
  end

  def self.search_moves(color, square)
    [in_front(color, square),
     in_front('left', color, square),
     in_front('right', color, square),
     two_squares_in_front(color, square)].compact
  end

  def self.in_front(direction = 'straight', color, square)
    column = case direction
             when 'straight'
               square[0]
             when 'left'
               prev(square[0])
             when 'right'
               square[0].next
             end

    row = color == 'white' ? square[1].next : prev(square[1])

    new_square = column + row

    new_square.match?(pattern(color)) ? new_square : nil
  end

  # Special move, only on Pawn's first move
  def self.two_squares_in_front(color, square)
    starting_row = color == 'white' ? '2' : '7'

    return unless square[1] == starting_row

    "#{square[0]}#{color == 'white' ? square[1].next.next : prev(prev(square[1]))}"
  end

  # Special movement
  def self.en_passant(color, square)
    column = square[0]

    row = color == 'white' ? square[1].next : prev(square[1])

    new_square = column + row

    new_square.match?(pattern(color)) ? new_square : nil
  end

  def self.left(square)
    leftward(square) { |next_square| return next_square }
  end

  def self.right(square)
    rightward(square) { |next_square| return next_square }
  end

  def self.pattern(color)
    color == 'white' ? /^[a-h][2-8]$/ : /^[a-h][1-7]$/
  end

  private_class_method :pattern
end
