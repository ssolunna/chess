# frozen_string_literal: true

require_relative '../lib/fen'
require_relative '../lib/game'

describe FEN do
  let(:empty_space) { ' ' }
  let(:chessgame) { Game.new }
  let(:board) { chessgame.instance_variable_get(:@board) }

  describe '#record_fen' do
    it 'records halfmove clock retrieved from chessgame class' do
      empty_board = board.chessboard

      chessgame.instance_variable_set(:@halfmove_clock, 1)

      expected_fen_record = '8/8/8/8/8/8/8/8 w - - 1 1'

      expect(chessgame).to receive(:halfmove_clock).and_call_original

      expect(chessgame.record_fen(empty_board))
        .to eq(expected_fen_record)
    end

    it 'records fullmove number retrieved from chessgame class' do
      empty_board = board.chessboard

      chessgame.instance_variable_set(:@fullmove_number, 40)

      expected_fen_record = '8/8/8/8/8/8/8/8 w - - 0 40'

      expect(chessgame).to receive(:fullmove_number).and_call_original

      expect(chessgame.record_fen(empty_board))
        .to eq(expected_fen_record)
    end

    context 'converts chessboard initial positions into FEN' do
      it 'records empty chessboard' do
        empty_board = board.chessboard

        expected_fen_record = '8/8/8/8/8/8/8/8 w - - 0 1'

        fen_record = chessgame.record_fen(empty_board)

        expect(fen_record).to eql(expected_fen_record)
      end

      it 'records traditional chessboard' do
        chessgame.send(:set_pieces)
        traditional_board = board.chessboard

        expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

        fen_record = chessgame.record_fen(traditional_board)

        expect(fen_record).to eql(expected_fen_record)
      end
    end

    context 'records pieces movements' do
      before { chessgame.send(:set_pieces) }
      let(:traditional_board) { board.chessboard }

      it 'records white knight moving from b1 to c3' do
        white_knight = traditional_board['b1']
        traditional_board['c3'] = white_knight
        traditional_board['b1'] = empty_space

        expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/2N5/PPPPPPPP/R1BQKBNR b KQkq - 0 1'

        fen_record = chessgame.record_fen(traditional_board, white_knight)

        expect(fen_record).to eql(expected_fen_record)
      end

      it 'records black pawn moving from h7 to h6' do
        black_pawn = traditional_board['h7']
        traditional_board['h6'] = black_pawn
        traditional_board['h7'] = empty_space

        expected_fen_record = 'rnbqkbnr/ppppppp1/7p/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

        fen_record = chessgame.record_fen(traditional_board, black_pawn)

        expect(fen_record).to eql(expected_fen_record)
      end
    end

    context 'records Castling and En Passant special movements' do
      before { chessgame.send(:set_pieces) }
      let(:traditional_board) { board.chessboard }

      it 'records Pawn en passant target square' do
        white_pawn = traditional_board['d2']
        white_pawn.player.move!(white_pawn, 'd4')

        expected_fen_record = 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq d3 0 1'

        fen_record = chessgame.record_fen(traditional_board, white_pawn)

        expect(fen_record).to eql(expected_fen_record)
      end

      context 'records castling availability' do
        it 'outputs - if both kings have made a move' do
          white_king = traditional_board['e1']
          white_king.player.move!(white_king, 'd2')

          black_king = traditional_board['e8']
          black_king.player.move!(black_king, 'd7')

          expected_fen_record = 'rnbq1bnr/pppkpppp/8/8/8/8/PPPKPPPP/RNBQ1BNR w - - 0 1'

          fen_record = chessgame.record_fen(traditional_board, black_king)

          expect(fen_record).to eql(expected_fen_record)
        end

        it 'outputs KQ if black king has made a move' do
          black_king = traditional_board['e8']
          black_king.player.move!(black_king, 'd7')

          expected_fen_record = 'rnbq1bnr/pppkpppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ - 0 1'

          fen_record = chessgame.record_fen(traditional_board, black_king)

          expect(fen_record).to eql(expected_fen_record)
        end

        it 'outputs kq if white king has made a move' do
          white_king = traditional_board['e1']
          white_king.player.move!(white_king, 'd2')

          expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPKPPPP/RNBQ1BNR b kq - 0 1'

          fen_record = chessgame.record_fen(traditional_board, white_king)

          expect(fen_record).to eql(expected_fen_record)
        end

        it 'outputs Qkq if white king cannot castle with rook at kingside' do
          white_rook_kingside = traditional_board['h1']
          allow(white_rook_kingside).to receive(:moves_log) { %w[h1 h4 h1] }

          expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b Qkq - 0 1'

          fen_record = chessgame.record_fen(traditional_board, white_rook_kingside)

          expect(fen_record).to eql(expected_fen_record)
        end

        it 'outputs KQk if black king cannot castle with rook at queenside' do
          black_rook_queenside = traditional_board['a8']
          allow(black_rook_queenside).to receive(:moves_log) { %w[a8 a5 a8] }

          expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQk - 0 1'

          fen_record = chessgame.record_fen(traditional_board, black_rook_queenside)

          expect(fen_record).to eql(expected_fen_record)
        end

        it 'outputs KQq if black king cannot castle with rook at kingside' do
          black_rook_kingside = traditional_board['h8']
          allow(black_rook_kingside).to receive(:moves_log) { %w[h8 h5 h8] }

          expected_fen_record = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQq - 0 1'

          fen_record = chessgame.record_fen(traditional_board, black_rook_kingside)

          expect(fen_record).to eql(expected_fen_record)
        end
      end
    end
  end
end
