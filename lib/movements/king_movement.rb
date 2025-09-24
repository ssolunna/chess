# frozen_string_literal: true

require_relative '../movements/chessboard_directions'

module KingMovement
  extend Directions
  include Directions

  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  def self.lay_out(layout = {}, queue = ['a1'])
    return layout if queue.empty?

    square = queue.first

    layout[square] = search_moves(square)

    layout[square].each do |move|
      next if layout.key?(move)

      queue.push(move)
    end

    queue.shift

    lay_out(layout, queue)
  end

  def self.search_moves(square)
    [up(square),
     up_left(square),
     up_right(square),
     down(square),
     down_left(square),
     down_right(square),
     left(square),
     right(square)].compact
  end

  def self.up(square)
    upward(square) { |next_square| return next_square }
  end

  def self.up_left(square)
    up_leftward(square) { |next_square| return next_square }
  end

  def self.up_right(square)
    up_rightward(square) { |next_square| return next_square }
  end

  def self.down(square)
    downward(square) { |next_square| return next_square }
  end

  def self.down_left(square)
    down_leftward(square) { |next_square| return next_square }
  end

  def self.down_right(square)
    down_rightward(square) { |next_square| return next_square }
  end

  def self.left(square)
    leftward(square) { |next_square| return next_square }
  end

  def self.right(square)
    rightward(square) { |next_square| return next_square }
  end
end
