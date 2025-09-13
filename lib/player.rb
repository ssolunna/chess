# frozen_string_literal: true

# Player of Chess
class Player
  attr_reader :pieces_moved_log

  def initialize(color, board)
    @color = color
    @board = board
    @pieces = []
    @touched_piece = nil
    @pieces_moved_log = []
  end

  def last_touched_piece?(piece)
    pieces_moved_log.last == piece
  end
end
