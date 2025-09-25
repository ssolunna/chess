# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new('color', {}) }
  let(:empty_square) { ' ' }

  describe '#move!' do
    let(:current_square) { 'b2' }
    let(:next_square) { 'b3' }
    let(:piece) { double('Piece', current_square: current_square, moves_log: [current_square]) }
    let(:board) { double('Board', chessboard: { 'b2' => piece, 'b3' => empty_square }) }

    before do
      player.instance_variable_set(:@board, board)
      allow(piece).to receive(:current_square=)
    end

    it 'assign piece current square to next square' do
      expect(piece).to receive(:current_square=).with(next_square)

      player.move!(next_square, piece, board.chessboard)
    end

    it 'change next square value to piece on the chessboard' do
      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { board.chessboard[next_square] }
        .to(piece)
    end

    it 'change current square value to empty on the chessboard' do
      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { board.chessboard[current_square] }
        .from(piece)
        .to(empty_square)
    end

    it 'add piece to player pieces moved log' do
      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { player.pieces_moved_log }
        .to(include(piece))
    end

    it 'add next square to piece moves log' do
      expect { player.move!(next_square, piece, board.chessboard) }
        .to change { piece.moves_log }
        .to(include(next_square))
    end

    context 'when there is an opponent piece on the next square' do
      it 'remove the opponent piece from the chessboard' do
        opponent = double('Piece', current_square: next_square, moves_log: [next_square])

        board = double('Board', chessboard: { 'b2' => piece, 'b3' => opponent })

        player.instance_variable_set(:@board, board)

        expect { player.move!(next_square, piece, board.chessboard) }
          .to change { board.chessboard }
          .from(include(next_square => opponent))
          .to(hash_not_including(have_value(opponent)))
      end
    end

    context 'when white pawn at g5 makes an en passant movement to h6' do
      let(:current_square) { 'g5' }
      let(:black_initial_square) { 'h7' }
      let(:double_stepped_square) { 'h5' }
      let(:square_passed_over) { 'h6' }

      let(:white_pawn) do
        double('WhitePawn', color: 'white',
                            current_square: current_square,
                            moves_log: [current_square])
      end

      let(:black_pawn) do
        double('BlackPawn', color: 'black',
                            current_square: double_stepped_square,
                            moves_log: [black_initial_square, double_stepped_square])
      end

      let(:board) do
        double('Board', chessboard: { current_square => white_pawn,
                                      double_stepped_square => black_pawn,
                                      square_passed_over => ' ' })
      end

      before do
        player.instance_variable_set(:@board, board)
        allow(player).to receive(:castling?)
        allow(white_pawn).to receive(:current_square=).with(square_passed_over)
        allow(white_pawn).to receive(:is_a?).with(Pawn).and_return(true)
      end

      it 'remove the double-stepping black pawn at h5 from the chessboard' do
        expect { player.move!(square_passed_over, white_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => black_pawn))
          .to(hash_not_including(have_value(black_pawn)))
      end

      it 'change h5 key to empty value on the chessboard' do
        expect { player.move!(square_passed_over, white_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => black_pawn))
          .to(include(double_stepped_square => empty_square))
      end
    end

    context 'when black pawn at b4 makes an en passant movement to a3' do
      let(:current_square) { 'b4' }
      let(:white_initial_square) { 'a2' }
      let(:double_stepped_square) { 'a4' }
      let(:square_passed_over) { 'a3' }

      let(:black_pawn) do
        double('BlackPawn', color: 'black',
                            current_square: current_square,
                            moves_log: [current_square])
      end

      let(:white_pawn) do
        double('BlackPawn', color: 'white',
                            current_square: double_stepped_square,
                            moves_log: [white_initial_square, double_stepped_square])
      end

      let(:board) do
        double('Board', chessboard: { current_square => black_pawn,
                                      double_stepped_square => white_pawn,
                                      square_passed_over => ' ' })
      end

      before do
        player.instance_variable_set(:@board, board)
        allow(player).to receive(:castling?)
        allow(black_pawn).to receive(:current_square=).with(square_passed_over)
        allow(black_pawn).to receive(:is_a?).with(Pawn).and_return(true)
      end

      it 'remove the double-stepping white pawn from the chessboard' do
        expect { player.move!(square_passed_over, black_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => white_pawn))
          .to(hash_not_including(have_value(white_pawn)))
      end

      it 'change double stepped square value to empty on the chessboard' do
        expect { player.move!(square_passed_over, black_pawn, board.chessboard) }
          .to change { board.chessboard }
          .from(include(double_stepped_square => white_pawn))
          .to(include(double_stepped_square => empty_square))
      end
    end

    context 'when king makes a castling move' do
      let(:color) { 'white' }
      let(:king) { double('King', color: color, current_square: current_square, moves_log: [current_square]) }
      let(:rook) { double('Rook', color: color, current_square: rook_at_square, moves_log: [rook_at_square]) }

      let(:board) do
        double('Board', chessboard: { current_square => king,
                                      rook_at_square => rook,
                                      square_moved_over => empty_square,
                                      to_square => empty_square })
      end

      before do
        player.instance_variable_set(:@board, board)

        allow(king).to receive(:is_a?).with(Pawn).and_return(false)
        allow(king).to receive(:is_a?).with(Rook).and_return(false)
        allow(king).to receive(:is_a?).with(King).and_return(true)
        allow(king).to receive(:current_square=)

        allow(rook).to receive(:is_a?).with(Pawn).and_return(false)
        allow(rook).to receive(:is_a?).with(King).and_return(false)
        allow(rook).to receive(:is_a?).with(Rook).and_return(true)
        allow(rook).to receive(:current_square=)
      end

      context 'when king at e1 moves to g1' do
        let(:current_square) { 'e1' }
        let(:square_moved_over) { 'f1' }
        let(:to_square) { 'g1' }
        let(:rook_at_square) { 'h1' }

        it 'change Rook current square to f1' do
          expect(rook).to receive(:current_square=).with(square_moved_over)

          player.move!(to_square, king, board.chessboard)
        end

        it 'move Rook to f1 on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(square_moved_over => empty_square))
            .to(include(square_moved_over => rook))
        end

        it 'change h1 key to empty value on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(rook_at_square => rook))
            .to(include(rook_at_square => empty_square))
        end
      end

      context 'when king at e1 moves to c1' do
        let(:current_square) { 'e1' }
        let(:square_moved_over) { 'd1' }
        let(:to_square) { 'c1' }
        let(:rook_at_square) { 'a1' }

        it 'change Rook current square to d1' do
          expect(rook).to receive(:current_square=).with(square_moved_over)

          player.move!(to_square, king, board.chessboard)
        end

        it 'move Rook to d1 on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(square_moved_over => empty_square))
            .to(include(square_moved_over => rook))
        end

        it 'change a1 key to empty value on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(rook_at_square => rook))
            .to(include(rook_at_square => empty_square))
        end
      end

      context 'when king at e8 moves to g8' do
        let(:current_square) { 'e8' }
        let(:square_moved_over) { 'f8' }
        let(:to_square) { 'g8' }
        let(:rook_at_square) { 'h8' }

        it 'change Rook current square to d8' do
          expect(rook).to receive(:current_square=).with(square_moved_over)

          player.move!(to_square, king, board.chessboard)
        end

        it 'move Rook to d8 on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(square_moved_over => empty_square))
            .to(include(square_moved_over => rook))
        end

        it 'change a8 key to empty value on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(rook_at_square => rook))
            .to(include(rook_at_square => empty_square))
        end
      end

      context 'when king at e8 moves to c8' do
        let(:current_square) { 'e8' }
        let(:square_moved_over) { 'd8' }
        let(:to_square) { 'c8' }
        let(:rook_at_square) { 'a8' }

        it 'change Rook current square to d8' do
          expect(rook).to receive(:current_square=).with(square_moved_over)

          player.move!(to_square, king, board.chessboard)
        end

        it 'move Rook to d8 on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(square_moved_over => empty_square))
            .to(include(square_moved_over => rook))
        end

        it 'change a8 key to empty value on chessboard' do
          expect { player.move!(to_square, king, board.chessboard) }
            .to change { board.chessboard }
            .from(include(rook_at_square => rook))
            .to(include(rook_at_square => empty_square))
        end
      end
    end
  end
end
