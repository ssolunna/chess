# frozen_string_literal: true

require_relative '../scoped_matchers_spec'
require_relative './shared_examples_movements_spec'
require_relative '../../lib/movements/pawn_movement'

describe PawnMovement do
  include MyHelpers

  describe '.lay_out' do
    let(:movements) { described_class.class_variable_get(:@@movements) }

    it 'returns a hash containing 56 white and black pawns movements' do
      expect(described_class.lay_out).to match(
        'white' => be_a_hash_of_size(56),
        'black' => be_a_hash_of_size(56)
      )
    end

    it 'expects all white pawn movements to be between ranges a-h and 2-8' do
      white_square_pattern = /^[a-h][2-8]$/

      expect(described_class.lay_out['white']).to all match(
        a_collection_containing_exactly(
          match(white_square_pattern),
          (be_an(Array).and all match(white_square_pattern))
        )
      )
    end

    it 'expects all black pawn movements to be between ranges a-h and 1-7' do
      black_square_pattern = /^[a-h][1-7]$/

      expect(described_class.lay_out['black']).to all match(
        a_collection_containing_exactly(
          match(black_square_pattern),
          (be_an(Array).and all match(black_square_pattern))
        )
      )
    end

    include_examples 'saves layout', { 'white' => {}, 'black' => {} }
  end

  describe '#from' do
    let!(:layout) { described_class.lay_out }

    context 'with white pawns' do
      let(:color) { 'white' }
      let(:white_pawn) { Class.new { extend PawnMovement } }

      context 'when current square is a2' do
        it 'returns an array of moves: a3, b3, a4' do
          current_square = 'a2'
          expected_moves = %w[a3 b3 a4]
          moves = white_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is b2' do
        it 'returns an array of moves: b3, a3, c3, b4' do
          current_square = 'b2'
          expected_moves = %w[b3 a3 c3 b4]
          moves = white_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is c8' do
        it 'returns an empty array' do
          current_square = 'c8'
          moves = white_pawn.moves_from(color, current_square)
          expect(moves.empty?).to eq(true)
        end
      end

      context 'when current square is e4' do
        it 'returns an array of moves: e5, d5, f5' do
          current_square = 'e4'
          expected_moves = %w[e5 d5 f5]
          moves = white_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is h7' do
        it 'returns an array of moves: h8, g8' do
          current_square = 'h7'
          expected_moves = %w[h8 g8]
          moves = white_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end
    end

    context 'with black pawns' do
      let(:color) { 'black' }
      let(:black_pawn) { Class.new { extend PawnMovement } }

      context 'when current square is a7' do
        it 'returns an array of moves: a6, b6, a5' do
          current_square = 'a7'
          expected_moves = %w[a6 b6 a5]
          moves = black_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is b7' do
        it 'returns an array of moves: b6, c6, a6, b5' do
          current_square = 'b7'
          expected_moves = %w[b6 c6 a6 b5]
          moves = black_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is c1' do
        it 'returns an empty array' do
          current_square = 'c1'
          moves = black_pawn.moves_from(color, current_square)
          expect(moves.empty?).to eq(true)
        end
      end

      context 'when current square is e4' do
        it 'returns an array of moves: e3, f3, d3' do
          current_square = 'e4'
          expected_moves = %w[e3 f3 d3]
          moves = black_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end

      context 'when current square is h2' do
        it 'returns an array of moves: h1, g1' do
          current_square = 'h2'
          expected_moves = %w[h1 g1]
          moves = black_pawn.moves_from(color, current_square)
          expect(moves).to match_array(expected_moves)
        end
      end
    end
  end
end
