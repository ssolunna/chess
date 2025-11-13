# frozen_string_literal: true

# The Chess Board
class Board
  EMPTY_SQUARE = ' '

  attr_reader :chessboard

  def initialize
    @chessboard = create_board
  end

  def display
    puts <<-HEREDOC

        a  b  c  d  e  f  g  h

    8  #{square('a8')}#{square('b8')}#{square('c8')}#{square('d8')}#{square('e8')}#{square('f8')}#{square('g8')}#{square('h8')}  8
    7  #{square('a7')}#{square('b7')}#{square('c7')}#{square('d7')}#{square('e7')}#{square('f7')}#{square('g7')}#{square('h7')}  7
    6  #{square('a6')}#{square('b6')}#{square('c6')}#{square('d6')}#{square('e6')}#{square('f6')}#{square('g6')}#{square('h6')}  6
    5  #{square('a5')}#{square('b5')}#{square('c5')}#{square('d5')}#{square('e5')}#{square('f5')}#{square('g5')}#{square('h5')}  5
    4  #{square('a4')}#{square('b4')}#{square('c4')}#{square('d4')}#{square('e4')}#{square('f4')}#{square('g4')}#{square('h4')}  4
    3  #{square('a3')}#{square('b3')}#{square('c3')}#{square('d3')}#{square('e3')}#{square('f3')}#{square('g3')}#{square('h3')}  3
    2  #{square('a2')}#{square('b2')}#{square('c2')}#{square('d2')}#{square('e2')}#{square('f2')}#{square('g2')}#{square('h2')}  2
    1  #{square('a1')}#{square('b1')}#{square('c1')}#{square('d1')}#{square('e1')}#{square('f1')}#{square('g1')}#{square('h1')}  1

        a  b  c  d  e  f  g  h

    HEREDOC
  end

  private
  
  def square(column_row)
    piece = get_token(chessboard[column_row])

    case column_row
    in /^[aceg][1357]$/ then brown_bg(piece)
    in /^[aceg][2468]$/ then beige_bg(piece)
    in /^[bdfh][1357]$/ then beige_bg(piece)
    in /^[bdfh][2468]$/ then brown_bg(piece)
    end
  end

  def get_token(piece)
    return EMPTY_SQUARE unless piece.is_a?(Piece)

    token(piece.class.name, piece.color)
  end

  def token(name, color)
    { 'King' => { 'white'=> "\u265A", 'black'=> "\e[30m\u265A" },
      'Queen' => { 'white'=> "\u265B", 'black'=> "\e[30m\u265B" },
      'Rook' => { 'white'=> "\u265C", 'black'=> "\e[30m\u265C" },
      'Bishop' => { 'white'=> "\u265D", 'black'=> "\e[30m\u265D" },
      'Knight' => { 'white'=> "\u265E", 'black'=> "\e[30m\u265E" },
      'Pawn' => { 'white'=> "\u265F", 'black'=> "\e[30m\u265F" }
    }[name][color]
  end

  def brown_bg(piece)
    "\e[48;5;130m #{piece} \e[0m"
  end

  def beige_bg(piece)
    "\e[48;5;179m #{piece} \e[0m"
  end

  def create_board
    board = {}

    '1'.upto('8') do |row|
      'a'.upto('h') do |column|
        board["#{column}#{row}"] = EMPTY_SQUARE
      end
    end

    board
  end
end
