# frozen_string_literal: true

module KingMovement
  @@movements = {}

  def self.lay_out(queue = ['a1'])
    return @@movements if queue.empty?

    square = queue.first

    @@movements[square] = [
      up(square),
      up('left', square),
      up('right', square),
      down(square),
      down('left', square),
      down('right', square),
      left(square),
      right(square)
    ].compact

    @@movements[square].each do |move|
      next if @@movements.key?(move)

      queue.push(move)
    end

    queue.shift

    lay_out(queue)
  end

  def moves_from(square)
    @@movements[square]
  end

  def self.up(direction = 'straight', square)
    column = case direction
             when 'straight'
               square[0]
             when 'left'
               prev(square[0])
             when 'right'
               square[0].next
             end

    row = square[1].next

    new_square = column + row

    new_square.match?(pattern) ? new_square : nil
  end

  def self.down(direction = 'straight', square)
    column = case direction
             when 'straight'
               square[0]
             when 'left'
               prev(square[0])
             when 'right'
               square[0].next
             end

    row = prev(square[1])

    new_square = column + row

    new_square.match?(pattern) ? new_square : nil
  end

  def self.left(square)
    column = prev(square[0])

    row = square[1]

    new_square = column + row

    new_square.match?(pattern) ? new_square : nil
  end

  def self.right(square)
    column = square[0].next

    row = square[1]

    new_square = column + row

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
