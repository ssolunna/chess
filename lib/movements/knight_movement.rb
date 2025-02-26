# frozen_string_literal: true

module KnightMovement
  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  def self.lay_out(layout = {}, queue = ['b1'])
    return layout if queue.empty?

    square = queue.first

    layout[square] = [
      up('left', square),
      up('right', square),
      down('left', square),
      down('right', square),
      right('up', square),
      right('down', square),
      left('up', square),
      left('down', square)
    ].compact

    layout[square].each do |move|
      next if layout.key?(move)

      queue.push(move)
    end

    queue.shift

    lay_out(layout, queue)
  end

  def self.up(direction, square)
    new_square = case direction
                 when 'left'
                   prev(square[0]) + square[1].next.next
                 when 'right'
                   square[0].next + square[1].next.next
                 end

    new_square.match?(pattern) ? new_square : nil
  end

  def self.down(direction, square)
    new_square = case direction
                 when 'left'
                   prev(square[0]) + prev(prev(square[1]))
                 when 'right'
                   square[0].next + prev(prev(square[1]))
                 end

    new_square.match?(pattern) ? new_square : nil
  end

  def self.right(direction, square)
    new_square = case direction
                 when 'up'
                   square[0].next.next + square[1].next
                 when 'down'
                   square[0].next.next + prev(square[1])
                 end

    new_square.match?(pattern) ? new_square : nil
  end

  def self.left(direction, square)
    new_square = case direction
                 when 'up'
                   prev(prev(square[0])) + square[1].next
                 when 'down'
                   prev(prev(square[0])) + prev(square[1])
                 end

    new_square.match?(pattern) ? new_square : nil
  end

  def self.prev(string)
    (string.to_i(36) - 1).to_s(36)
  end

  def self.pattern
    /^[a-h][1-8]$/
  end

  private_class_method :prev, :pattern
end
