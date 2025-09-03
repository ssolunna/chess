# frozen_string_literal: true

# Chessboard Pieces Directions
module Directions
  def upward(square)
    return to_enum(:upward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = square[0] + square[1].next

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def downward(square)
    return to_enum(:downward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = square[0] + prev(square[1])

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def rightward(square)
    return to_enum(:rightward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = square[0].next + square[1]

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def leftward(square)
    return to_enum(:leftward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = prev(square[0]) + square[1]

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def up_rightward(square)
    return to_enum(:up_rightward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = square[0].next + square[1].next

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def up_leftward(square)
    return to_enum(:up_leftward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = prev(square[0]) + square[1].next

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def down_rightward(square)
    return to_enum(:down_rightward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = square[0].next + prev(square[1])

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  def down_leftward(square)
    return to_enum(:down_leftward) unless block_given?

    return unless match_square_pattern?(square)

    loop do
      next_square = prev(square[0]) + prev(square[1])

      break unless match_square_pattern?(next_square)

      yield next_square

      square = next_square
    end
  end

  private

  def prev(string)
    (string.to_i(36) - 1).to_s(36)
  end

  def match_square_pattern?(square)
    /^[a-h][1-8]$/ =~ square.to_s
  end
end
