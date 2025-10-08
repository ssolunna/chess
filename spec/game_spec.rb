# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:empty_square) { ' ' }
  let(:chessgame) { described_class.new }
  let(:board) { chessgame.instance_variable_get(:@board) }
  let(:white_player) { chessgame.instance_variable_get(:@white_player) }
  let(:black_player) { chessgame.instance_variable_get(:@black_player) }

  describe '#set_pieces' do
    context 'position white pieces on board' do
      let(:color) { 'white' }

      %w[a2 b2 c2 d2 e2 f2 g2 h2].each do |square|
        it "places white pawn on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Pawn) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end
      end

      %w[a1 h1].each do |square|
        it "places white rook on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Rook) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end
      end

      %w[b1 g1].each do |square|
        it "places white knight on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Knight) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end
      end

      %w[c1 f1].each do |square|
        it "places white bishop on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Bishop) &
                have_attributes(color: color,
                                current_square: square,
                                player: white_player))
        end
      end

      it 'places white queen on d1 square' do
        square = 'd1'

        expect { chessgame.set_pieces }
          .to change { board.chessboard[square] }
          .from(empty_square)
          .to(be_a(Queen) &
              have_attributes(color: color,
                              current_square: square,
                              player: white_player))
      end

      it 'places white king on e1 square' do
        square = 'e1'

        expect { chessgame.set_pieces }
          .to change { board.chessboard[square] }
          .from(empty_square)
          .to(be_a(King) &
              have_attributes(color: color,
                              current_square: square,
                              player: white_player))
      end
    end

    context 'position black pieces on board' do
      let(:color) { 'black' }

      %w[a7 b7 c7 d7 e7 f7 g7 h7].each do |square|
        it "places black pawn on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Pawn) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end
      end

      %w[a8 h8].each do |square|
        it "places black rook on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Rook) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end
      end

      %w[b8 g8].each do |square|
        it "places black knight on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Knight) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end
      end

      %w[c8 f8].each do |square|
        it "places black bishop on #{square} square" do
          expect { chessgame.set_pieces }
            .to change { board.chessboard[square] }
            .from(empty_square)
            .to(be_a(Bishop) &
                have_attributes(color: color,
                                current_square: square,
                                player: black_player))
        end
      end

      it 'places black queen on d8 square' do
        square = 'd8'

        expect { chessgame.set_pieces }
          .to change { board.chessboard[square] }
          .from(empty_square)
          .to(be_a(Queen) &
              have_attributes(color: color,
                              current_square: square,
                              player: black_player))
      end

      it 'places black king on e8 square' do
        square = 'e8'

        expect { chessgame.set_pieces }
          .to change { board.chessboard[square] }
          .from(empty_square)
          .to(be_a(King) &
              have_attributes(color: color,
                              current_square: square,
                              player: black_player))
      end
    end
  end

  describe '#set_up_pieces_movements' do
    it 'sends messages to set up all 6 pieces movements' do
      expect(PawnMovement).to receive(:set_up)
      expect(RookMovement).to receive(:set_up)
      expect(KnightMovement).to receive(:set_up)
      expect(BishopMovement).to receive(:set_up)
      expect(QueenMovement).to receive(:set_up)
      expect(KingMovement).to receive(:set_up)

      chessgame.set_up_pieces_movements
    end
  end
end
