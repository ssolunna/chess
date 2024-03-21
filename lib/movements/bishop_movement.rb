# frozen_string_literal: true

module BishopMovement
  @@movements = {}

  def self.lay_out(queue = %w[a1 h1])
    return @@movements if queue.empty?

    square = queue.first

    @@movements[square] = [
      up_left(square),
      up_right(square),
      down_left(square),
      down_right(square)
    ].flatten!

    @@movements[square].each do |move|
      next if @@movements.key?(move)

      queue.push(move) unless queue.include?(move)
    end

    queue.shift

    lay_out(queue)
  end

  def moves_from(square)
    @@movements[square]
  end

  def self.up_left(square)
    new_squares = []

    loop do
      next_square = prev(square[0]) + square[1].next

      return new_squares unless next_square.match?(pattern)

      new_squares << next_square

      square = next_square
    end
  end

  def self.up_right(square)
    new_squares = []

    loop do
      next_square = square[0].next + square[1].next

      return new_squares unless next_square.match?(pattern)

      new_squares << next_square

      square = next_square
    end
  end

  def self.down_left(square)
    new_squares = []

    loop do
      next_square = prev(square[0]) + prev(square[1])

      return new_squares unless next_square.match?(pattern)

      new_squares << next_square

      square = next_square
    end
  end

  def self.down_right(square)
    new_squares = []

    loop do
      next_square = square[0].next + prev(square[1])

      return new_squares unless next_square.match?(pattern)

      new_squares << next_square

      square = next_square
    end
  end

  def self.prev(string)
    (string.to_i(36) - 1).to_s(36)
  end

  def self.pattern
    /^[a-h][1-8]$/
  end

  private_class_method :prev, :pattern
end
