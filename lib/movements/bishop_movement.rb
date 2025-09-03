# frozen_string_literal: true

require_relative '../movements/chessboard_directions'

module BishopMovement
  include Directions
  extend Directions

  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  def self.lay_out(layout = {}, queue = %w[a1 h1])
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
    [up_left(square),
     up_right(square),
     down_left(square),
     down_right(square)].flatten
  end

  def self.up_left(square)
    new_squares = []

    up_leftward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.up_right(square)
    new_squares = []

    up_rightward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.down_left(square)
    new_squares = []

    down_leftward(square) { |next_square| new_squares << next_square }

    new_squares
  end

  def self.down_right(square)
    new_squares = []

    down_rightward(square) { |next_square| new_squares << next_square }

    new_squares
  end
end
