# frozen_string_literal: true

module RookMovement
  @@movements = nil

  def self.set_up
    @@movements = lay_out
  end

  def self.lay_out(layout = {}, queue = ['a1'])
    return layout if queue.empty?

    square = queue.first

    layout[square] = [
      forward(square),
      backward(square),
      sideways('left', square),
      sideways('right', square)
    ].flatten!

    layout[square].each do |move|
      next if layout.key?(move)

      queue.push(move) unless queue.include?(move)
    end

    queue.shift

    lay_out(layout, queue)
  end

  def moves_from(square)
    @@movements[square]
  end

  def self.forward(square)
    column = square[0]

    rows = square[1].next.to_i.upto(8).inject([]) { |array, row| array.push row }

    rows.map { |row| column + row.to_s }
  end

  def self.backward(square)
    column = square[0]

    rows = prev(square[1]).to_i.downto(1).inject([]) { |array, row| array.push row }

    rows.map { |row| column + row.to_s }
  end

  def self.sideways(direction, square)
    columns = case direction
              when 'left'
                ('a'..prev(square[0])).inject([]) { |array, column| array.push column }
              when 'right'
                (square[0].next..'h').inject([]) { |array, column| array.push column }
              end

    row = square[1]

    columns.map { |column| column + row }
  end

  def self.prev(string)
    (string.to_i(36) - 1).to_s(36)
  end

  private_class_method :prev
end
