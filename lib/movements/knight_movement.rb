# frozen_string_literal: true

require_relative '../movements/chessboard_directions'

module KnightMovement
  extend Directions

  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  private

  def self.lay_out(layout = {}, queue = ['b1'])
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
    [up('left', square),
     up('right', square),
     down('left', square),
     down('right', square),
     right('up', square),
     right('down', square),
     left('up', square),
     left('down', square)].compact
  end

  def self.up(direction, square)
    new_square = case direction
                 when 'left'
                   prev(square[0]) + square[1].next.next
                 when 'right'
                   square[0].next + square[1].next.next
                 end

    match_square_pattern?(new_square) ? new_square : nil
  end

  def self.down(direction, square)
    new_square = case direction
                 when 'left'
                   prev(square[0]) + prev(prev(square[1]))
                 when 'right'
                   square[0].next + prev(prev(square[1]))
                 end

    match_square_pattern?(new_square) ? new_square : nil
  end

  def self.right(direction, square)
    new_square = case direction
                 when 'up'
                   square[0].next.next + square[1].next
                 when 'down'
                   square[0].next.next + prev(square[1])
                 end

    match_square_pattern?(new_square) ? new_square : nil
  end

  def self.left(direction, square)
    new_square = case direction
                 when 'up'
                   prev(prev(square[0])) + square[1].next
                 when 'down'
                   prev(prev(square[0])) + prev(square[1])
                 end

    match_square_pattern?(new_square) ? new_square : nil
  end
end
