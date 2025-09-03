# frozen_string_literal: true

require_relative './rook_movement'
require_relative './bishop_movement'

module QueenMovement
  @@movements = nil

  def moves_from(square)
    @@movements[square]
  end

  def self.set_up
    @@movements = lay_out
  end

  def self.lay_out
    layout = RookMovement.lay_out
    bishop_movements = BishopMovement.lay_out

    bishop_movements.each { |square, moves| layout[square].push(*moves) }
    layout
  end
end
