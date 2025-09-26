# frozen_string_literal: true

require_relative '../movements/chessboard_directions'

module RookMovement
  include Directions
  extend Directions

  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  private

  def self.lay_out(layout = {}, queue = ['a1'])
    return layout if queue.empty?

    square = queue.first

    layout[square] = search_moves(square)

    layout[square].each do |move|
      next if layout.key?(move)

      queue.push(move) unless queue.include?(move)
    end

    queue.shift

    lay_out(layout, queue)
  end

  def self.search_moves(square)
    [up(square),
     down(square),
     left(square),
     right(square)].flatten
  end

  def self.up(square)
    new_squares = []

    upward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.down(square)
    new_squares = []

    downward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.left(square)
    new_squares = []

    leftward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.right(square)
    new_squares = []

    rightward(square) { |next_square| new_squares << next_square }

    new_squares
  end
end
