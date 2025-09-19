# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/pieces/pawn'

describe Player do
  subject(:player) { Player.new('color', {}) }
  let(:empty_square) { ' ' }

  describe '#move!' do
    it 'assign piece current square to next square' do
      current_square = 'b2'
      next_square = 'b3'

      piece = Pawn.new('white', current_square)
      board = double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square })

      player.instance_variable_set(:@board, board)

      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { piece.current_square }
        .from(current_square)
        .to(next_square)
    end

    it 'change next square value to piece on the chessboard' do
      current_square = 'b2'
      next_square = 'b3'

      piece = Pawn.new('white', current_square)
      board = double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square })

      player.instance_variable_set(:@board, board)

      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { board.chessboard[next_square] }
        .to(piece)
    end

    it 'change current square value to empty on the chessboard' do
      current_square = 'b2'
      next_square = 'b3'

      piece = Pawn.new('white', current_square)
      board = double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square })

      player.instance_variable_set(:@board, board)

      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { board.chessboard[current_square] }
        .from(piece)
        .to(empty_square)
    end

    it 'add piece to player pieces moved log' do
      current_square = 'b2'
      next_square = 'b3'

      piece = Pawn.new('white', current_square)
      board = double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square })

      player.instance_variable_set(:@board, board)

      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { player.pieces_moved_log }
        .to(include(piece))
    end

    it 'add next square to piece moves log' do
      current_square = 'b2'
      next_square = 'b3'

      piece = Pawn.new('white', current_square)
      board = double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square })

      player.instance_variable_set(:@board, board)

      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { piece.moves_log }
        .to(include(next_square))
    end

    context 'when there is an opponent piece on the next square' do
      it 'remove the opponent piece from the chessboard' do
        current_square = 'b2'
        next_square = 'b3'

        piece = Pawn.new('white', current_square)
        opponent = Pawn.new('black', next_square)
        board = double('Board', chessboard: { 'b2' => piece, 'b3' => opponent })

        player.instance_variable_set(:@board, board)

        expect { player.move!(next_square, piece, board.chessboard) }
          .to change { board.chessboard }
          .from(include(next_square => opponent))
          .to(hash_not_including(have_value(opponent)))
      end
    end

    context 'when white pawn does an en passant movement' do
      it 'remove the double-stepping black pawn from the chessboard' do
        current_square = 'g5'
        double_stepped_square = 'h5'
        square_passed_over = 'h6'

        white_pawn = Pawn.new('white', current_square)
        black_pawn = Pawn.new('black', double_stepped_square)

        board = double('Board', chessboard: { 'g5' => white_pawn, 'h5' => black_pawn, 'h6' => empty_square })

        player.instance_variable_set(:@board, board)

        expect { player.move!(square_passed_over, white_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => black_pawn))
          .to(hash_not_including(have_value(black_pawn)))
      end

      it 'change double stepped square value to empty on the chessboard' do
        current_square = 'g5'
        double_stepped_square = 'h5'
        square_passed_over = 'h6'

        white_pawn = Pawn.new('white', current_square)
        black_pawn = Pawn.new('black', double_stepped_square)

        board = double('Board', chessboard: { 'g5' => white_pawn, 'h5' => black_pawn, 'h6' => empty_square })

        player.instance_variable_set(:@board, board)

        expect { player.move!(square_passed_over, white_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => black_pawn))
          .to(include(double_stepped_square => empty_square))
      end
    end

    context 'when black pawn does an en passant movement' do
      it 'remove the double-stepping white pawn from the chessboard' do
        current_square = 'b4'
        double_stepped_square = 'a4'
        square_passed_over = 'a3'

        black_pawn = Pawn.new('black', current_square)
        white_pawn = Pawn.new('white', double_stepped_square)

        board = double('Board', chessboard: { 'b4' => black_pawn, 'a4' => white_pawn, 'a3' => empty_square })

        player.instance_variable_set(:@board, board)

        expect { player.move!(square_passed_over, black_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => white_pawn))
          .to(hash_not_including(have_value(white_pawn)))
      end

      it 'change double stepped square value to empty on the chessboard' do
        current_square = 'b4'
        double_stepped_square = 'a4'
        square_passed_over = 'a3'

        black_pawn = Pawn.new('black', current_square)
        white_pawn = Pawn.new('white', double_stepped_square)

        board = double('Board', chessboard: { 'b4' => black_pawn, 'a4' => white_pawn, 'a3' => empty_square })

        player.instance_variable_set(:@board, board)

        expect { player.move!(square_passed_over, black_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => white_pawn))
          .to(include(double_stepped_square => empty_square))
      end
    end
  end
end
