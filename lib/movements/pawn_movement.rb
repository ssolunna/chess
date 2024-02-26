# frozen_string_literal: true

module PawnMovement
  @movements = {}

  def self.lay_out(queue = %w[a2 b2 c2 d2 e2 f2 g2 h2])
    return @movements if queue.empty?

    square = queue.first

    @movements[square] = [
      in_front(square),
      in_front_on_left(square),
      in_front_on_right(square),
      two_squares_in_front(square)
    ].compact

    @movements[square].each do |move|
      next if @movements.key?(move)

      queue.push(move) unless queue.include?(move)
    end

    queue.shift

    lay_out(queue)
  end

  private

  def from(square)
    @movements[square]
  end

  def self.in_front(square)
    new_square = "#{square[0]}#{square[1].next}"

    new_square.match?(/^[a-h][2-8]$/) ? new_square : nil
  end

  def self.in_front_on_left(square)
    new_square = "#{prev(square[0])}#{square[1].next}"

    new_square.match?(/^[a-h][2-8]$/) ? new_square : nil
  end

  def self.in_front_on_right(square)
    new_square = "#{square[0].next}#{square[1].next}"

    new_square.match?(/^[a-h][2-8]$/) ? new_square : nil
  end

  # Special move, only on Pawn's first move
  def self.two_squares_in_front(square)
    return unless square[1] == '2' # White Pawn's starting square

    new_square = "#{square[0]}#{square[1].next.next}"

    new_square.match?(/^[a-h][2-8]$/) ? new_square : nil
  end

  def self.prev(string)
    (string.to_i(36) - 1).to_s(36)
  end

  private_class_method :in_front, :in_front_on_left, :in_front_on_right, :two_squares_in_front, :prev
end
