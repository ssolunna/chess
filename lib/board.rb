# frozen_string_literal: true

# The Chess Board
class Board
  EMPTY_SQUARE = ' '

  attr_reader :chessboard

  def initialize
    @chessboard = create_board
  end

  private

  def create_board
    board = {}

    'a'.upto('h') do |column|
      '1'.upto('8') do |row|
        board["#{column}#{row}"] = EMPTY_SQUARE
      end
    end

    board
  end
end
