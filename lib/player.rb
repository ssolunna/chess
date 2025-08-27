# frozen_string_literal: true

class Player
  def initialize(color, board)
    @color = color
    @board = board 
    @touched_piece = nil
    @pieces_moved_log = []
  end

  def last_touched_piece?(piece)
    @pieces_moved_log.last === piece
  end
end
