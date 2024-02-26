# frozen_string_literal: true

require_relative '../../lib/movements/pawn_movement'

describe PawnMovement do
  describe '.lay_out' do
    context 'with white pawns' do
      let(:white_pawn_movements) { described_class.lay_out }
      let(:square_pattern) { /^[a-h][2-8]$/ }
      let(:movements) { described_class.instance_variable_get(:@movements) }

      after do
        described_class.instance_variable_set(:@movements, {})
      end

      it 'lay out a Hash of 56 unique squares (movements)' do
        expect(white_pawn_movements).to be_a(Hash)
        expect(white_pawn_movements.keys.uniq.size).to eq(56)
        expect(white_pawn_movements.keys).to all match(square_pattern)
      end

      it 'copies all moves to the @movements class variable' do
        moves = described_class.lay_out

        described_class.instance_variable_set(:@movements, {})

        expect { described_class.lay_out }.to \
          change { movements }
          .to eq(moves)
      end

      context 'when current square is a2' do
        it 'returns an array of moves: a3, b3, a4' do
          current_square = 'a2'
          expected_moves = %w[a3 b3 a4]
          moves = white_pawn_movements[current_square]
          expect(moves).to eq(expected_moves)
        end
      end

      context 'when current square is b2' do
        it 'returns an array of moves: b3, a3, c3, b4' do
          current_square = 'b2'
          expected_moves = %w[b3 a3 c3 b4]
          moves = white_pawn_movements[current_square]
          expect(moves).to eq(expected_moves)
        end
      end

      context 'when current square is c8' do
        it 'returns an empty array' do
          current_square = 'c8'
          moves = white_pawn_movements[current_square]
          expect(moves.empty?).to eq(true)
        end
      end

      context 'when current square is e4' do
        it 'returns an array of moves: e5, d5, f5' do
          current_square = 'e4'
          expected_moves = %w[e5 d5 f5]
          moves = white_pawn_movements[current_square]
          expect(moves).to eq(expected_moves)
        end
      end

      context 'when current square is h7' do
        it 'returns an array of moves: h8, g8' do
          current_square = 'h7'
          expected_moves = %w[h8 g8]
          moves = white_pawn_movements[current_square]
          expect(moves).to eq(expected_moves)
        end
      end
    end
  end
end
