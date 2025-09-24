# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/queen'
require_relative '../../lib/player'
require_relative '../../lib/movements/king_movement'

RSpec.shared_examples 'a king' do
  describe '#search_legal_moves' do
    context 'when king is at e1' do
      context 'if d2 empty, same-color at d1, e2, f1 and opponent at f2' do
        it 'returns array of squares: d2, f2' do
          current_square = 'e1'
          board = { 'd2' => ' ',
                    'e2' => double(color: color),
                    'f2' => double(color: opponent_color),
                    'd1' => double(color: color),
                    'f1' => double(color: color) }
          expected_array = %w[d2 f2]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at e8' do
      context 'if d7, f7 empty, same-color piece at e7 and opponent at d8, f8' do
        it 'returns array of squares: d7, f7, d8, f8' do
          current_square = 'e8'
          board = { 'e7' => double(color: color),
                    'd7' => ' ',
                    'f7' => ' ',
                    'd8' => double(color: opponent_color),
                    'f8' => double(color: opponent_color) }
          expected_array = %w[d7 f7 d8 f8]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at a8' do
      context 'if b8 empty, same-color at b7 and opponent at a7' do
        it 'returns array of squares: b8, a7' do
          current_square = 'a8'
          board = { 'b7' => double(color: color),
                    'b8' => ' ',
                    'a7' => double(color: opponent_color) }
          expected_array = %w[b8 a7]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at h1' do
      context 'if same-color pieces at g1, g2, h2' do
        it 'returns an empty array' do
          current_square = 'h1'
          board = { 'g1' => double(color: color),
                    'g2' => double(color: color),
                    'h2' => double(color: color) }

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to be_empty
        end
      end
    end

    context 'when king is at e5' do
      context 'if e6, f5, f4, d6 empty, same-color at d5, f6
          and opponent at e4, d4' do
        it 'returns array of squares: e6, f5, f4, d6, e4, d4' do
          current_square = 'e5'
          board = { 'd6' => ' ',
                    'e6' => ' ',
                    'f6' => double(color: color),
                    'f5' => ' ',
                    'f4' => ' ',
                    'e4' => double(color: opponent_color),
                    'd4' => double(color: opponent_color),
                    'd5' => double(color: color) }
          expected_array = %w[e6 f5 f4 d6 e4 d4]

          king = described_class.new(color, current_square)
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          legal_moves = king.search_legal_moves(board)

          expect(legal_moves).to match_array(expected_array)
        end
      end
    end

    context 'when king is at e1 and rook at a1' do
      let(:current_square) { 'e1' }
      let(:king) { described_class.new(color, current_square) }
      let(:rook) do
        double('Rook', color: color,
                       current_square: 'a1',
                       is_a?: true)
      end

      let(:board) do
        { 'e1' => king,
          'a1' => rook,
          'b1' => ' ',
          'b2' => ' ',
          'b3' => ' ',
          'c1' => ' ',
          'c2' => ' ',
          'd1' => ' ',
          'd2' => ' ',
          'e2' => ' ',
          'e3' => ' ',
          'e4' => ' ',
          'f2' => double(color: color),
          'f1' => double(color: color) }
      end

      before do
        king.instance_variable_set(:@moves, king.moves_from(current_square))
        allow(rook).to receive(:moves_log).and_return(['a1'])
      end

      context 'when all castling conditions are met' do
        it 'should include c1' do
          expect(king.search_legal_moves(board)).to include('c1')
        end
      end

      context 'when any castling condition is not met' do
        context 'if king has already moved' do
          it 'should not include c1' do
            king.instance_variable_set(:@moves_log, [current_square, 'e2', current_square])

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        context 'if rook has already moved' do
          it 'should not include c1' do
            allow(rook).to receive(:moves_log).and_return(%w[a1 a2 a1])

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        context 'if king is in check' do
          it 'should not include c1' do
            opponent = Queen.new(opponent_color, 'e5')
            board['e5'] = opponent

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        context 'if an opponent is attacking square d1' do
          it 'should not include c1' do
            opponent = Queen.new(opponent_color, 'a4')
            board['a4'] = opponent

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        context 'if an opponent is attacking square c1' do
          it 'should not include c1' do
            opponent = Queen.new(opponent_color, 'a3')
            board['a3'] = opponent

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        %w[b1 c1 d1].each do |square|
          context "if there is a piece at #{square}" do
            it 'should not include c1' do
              opponent = double(color: opponent_color, current_square: square)
              board[square] = opponent

              expect(king.search_legal_moves(board)).not_to include('c1')
            end
          end
        end

        context 'if king moves to e2' do
          it 'should not include c1' do
            king.instance_variable_set(:@moves_log, [current_square, 'e2'])
            board['e2'] = king
            board['e1'] = ' '

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end

        context 'if rook moves to a2' do
          it 'should not include c1' do
            allow(rook).to receive(:moves_log).and_return(%w[a1 a2])
            board['a2'] = rook
            board['a1'] = ' '

            expect(king.search_legal_moves(board)).not_to include('c1')
          end
        end
      end
    end

    context 'when king is at e8 and rook at h8' do
      let(:current_square) { 'e8' }
      let(:king) { described_class.new(color, current_square) }
      let(:rook) do
        double('Rook', color: color,
                       current_square: 'h8',
                       is_a?: true)
      end

      let(:board) do
        { 'e8' => king,
          'h8' => rook,
          'f8' => ' ',
          'g8' => ' ',
          'e7' => ' ',
          'e6' => ' ',
          'f6' => ' ',
          'g7' => ' ',
          'd8' => double(color: color),
          'd7' => double(color: color) }
      end

      before do
        king.instance_variable_set(:@moves, king.moves_from(current_square))
        allow(rook).to receive(:moves_log).and_return(['h8'])
      end

      context 'when all castling conditions are met' do
        it 'should include g8' do
          expect(king.search_legal_moves(board)).to include('g8')
        end
      end

      context 'when any castling condition is not met' do
        context 'if king has already moved' do
          it 'should not include g8' do
            king.instance_variable_set(:@moves_log, [current_square, 'e7', current_square])

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        context 'if rook has already moved' do
          it 'should not include g8' do
            allow(rook).to receive(:moves_log).and_return(%w[h8 h7 h8])

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        context 'if king is in check' do
          it 'should not include g8' do
            opponent = Queen.new(opponent_color, 'e5')
            board['e5'] = opponent

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        context 'if an opponent is attacking square f8' do
          it 'should not include g8' do
            opponent = Queen.new(opponent_color, 'h6')
            board['h6'] = opponent

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        context 'if an opponent is attacking square g8' do
          it 'should not include g8' do
            opponent = Queen.new(opponent_color, 'h7')
            board['h7'] = opponent

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        %w[f8 g8].each do |square|
          context "if there is a piece at #{square}" do
            it 'should not include g8' do
              opponent = double(color: opponent_color, current_square: square)
              board[square] = opponent

              expect(king.search_legal_moves(board)).not_to include('g8')
            end
          end
        end

        context 'if king moves to e7' do
          it 'should not include g8' do
            king.instance_variable_set(:@moves_log, [current_square, 'e7'])
            board['e7'] = king
            board['e8'] = ' '

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end

        context 'if rook moves to h7' do
          it 'should not include g8' do
            allow(rook).to receive(:moves_log).and_return(%w[h8 h7])
            board['h7'] = rook
            board['h8'] = ' '

            expect(king.search_legal_moves(board)).not_to include('g8')
          end
        end
      end
    end

    context 'when king is at e1 and rooks are at a1 and h1' do
      let(:current_square) { 'e1' }
      let(:king) { described_class.new(color, current_square) }

      let(:first_rook) do
        double('Rook', color: color,
                       current_square: 'a1',
                       is_a?: true)
      end

      let(:second_rook) do
        double('Rook', color: color,
                       current_square: 'h1',
                       is_a?: true)
      end

      let(:board) do
        { 'e1' => king,
          'a1' => first_rook,
          'b1' => ' ',
          'c1' => ' ',
          'd1' => ' ',
          'd2' => ' ',
          'e2' => ' ',
          'f2' => double(color: color),
          'f1' => ' ',
          'g1' => ' ',
          'h1' => second_rook }
      end

      context 'when all castling conditions are met' do
        it 'should include c1 and g1' do
          allow(first_rook).to receive(:moves_log).and_return(['a1'])
          allow(second_rook).to receive(:moves_log).and_return(['h1'])

          king.instance_variable_set(:@moves, king.moves_from(current_square))

          expect(king.search_legal_moves(board)).to include('c1', 'g1')
        end
      end
    end

    context 'when king is at e8 and rooks are at a8 and h8' do
      let(:current_square) { 'e8' }
      let(:king) { described_class.new(color, current_square) }

      let(:first_rook) do
        double('Rook', color: color,
                       current_square: 'a8',
                       is_a?: true)
      end

      let(:second_rook) do
        double('Rook', color: color,
                       current_square: 'h8',
                       is_a?: true)
      end

      let(:board) do
        { 'e8' => king,
          'a8' => first_rook,
          'b8' => ' ',
          'c8' => ' ',
          'd8' => ' ',
          'd7' => ' ',
          'e7' => ' ',
          'f7' => double(color: color),
          'f8' => ' ',
          'g8' => ' ',
          'h8' => second_rook }
      end

      context 'when all castling conditions are met' do
        it 'should include c8 and g8' do
          allow(first_rook).to receive(:moves_log).and_return(['a8'])
          allow(second_rook).to receive(:moves_log).and_return(['h8'])

          king.instance_variable_set(:@moves, king.moves_from(current_square))

          expect(king.search_legal_moves(board)).to include('c8', 'g8')
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    let!(:player) { Player.new('color', {}) }

    context 'when king is at f4' do
      let(:current_square) { 'f4' }
      let(:king) { described_class.new(color, current_square) }

      before { king.instance_variable_set(:@player, player) }

      context 'when legal moves are [e5, f5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 f5 g5 g4 g3 f3 e3 e4] }

        context 'if king is in check at f4 by opponent queen at d6' do
          it 'returns array of squares: f5, g5, g4, f3, e3, e4' do
            opponent = Queen.new(opponent_color, 'd6')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d6'))

            board = { 'd6' => opponent,
                      'f4' => king,
                      'e5' => ' ',
                      'f5' => ' ',
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[f5 g5 g4 f3 e3 e4]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is in check at f4 by opponent queen at f5' do
          it 'returns array of squares: f5 e3 g3' do
            opponent = Queen.new(opponent_color, 'f5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('f5'))

            board = { 'f4' => king,
                      'e5' => ' ',
                      'f5' => opponent,
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[f5 e3 g3]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end

        context 'if king is not in check at f4 by opponent queens at d5 and g6' do
          it 'returns array of squares: e3' do
            opponent = Queen.new(opponent_color, 'd5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('d5'))

            opponent_two = Queen.new(opponent_color, 'g6')
            opponent_two.instance_variable_set(:@moves, opponent_two.moves_from('g6'))

            board = { 'd5' => opponent,
                      'g6' => opponent_two,
                      'f4' => king,
                      'e5' => ' ',
                      'f5' => ' ',
                      'g5' => ' ',
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[e3]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when legal moves are [e5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 g5 g4 g3 f3 e3 e4] }

        context 'if king is in check at f4 by opponent queen at g5' do
          it 'returns array of squares: e5, g5, f3, e4' do
            opponent = Queen.new(opponent_color, 'g5')
            opponent.instance_variable_set(:@moves, opponent.moves_from('g5'))

            board = { 'f4' => king,
                      'e5' => ' ',
                      'f5' => double(color: color),
                      'g5' => opponent,
                      'g4' => ' ',
                      'g3' => ' ',
                      'f3' => ' ',
                      'e3' => ' ',
                      'e4' => ' ' }

            expected_array = %w[e5 g5 f3 e4]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end

    context 'when king is at a1' do
      let(:current_square) { 'a1' }
      let(:king) { described_class.new(color, current_square) }

      before { king.instance_variable_set(:@player, player) }

      context 'when legal moves are [a2, b2, b1]' do
        let(:legal_moves) { %w[a2 b2 b1] }

        context 'if king is in check at a1 by opponent queen at c2
            but not in check by another opponent queen at b4' do
          it 'returns an empty array' do
            opponent = Queen.new(opponent_color, 'c2')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c2'))

            opponent_two = Queen.new(opponent_color, 'b4')
            opponent_two.instance_variable_set(:@moves, opponent_two.moves_from('b4'))

            board = { 'c2' => opponent,
                      'b4' => opponent_two,
                      'a1' => king,
                      'a2' => ' ',
                      'a3' => ' ',
                      'b2' => ' ',
                      'b1' => ' ' }

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end
      end

      context 'when legal moves are [b1]' do
        let(:legal_moves) { %w[b1] }

        context 'if king is not in check at a1 by opponent queen at c2' do
          it 'returns an empty array' do
            opponent = Queen.new(opponent_color, 'c2')
            opponent.instance_variable_set(:@moves, opponent.moves_from('c2'))

            board = { 'c2' => opponent,
                      'a1' => king,
                      'a2' => double(color: color),
                      'a3' => ' ',
                      'b2' => double(color: color),
                      'c1' => double(color: color),
                      'b1' => ' ' }

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end
      end
    end

    context 'when king is at e8' do
      let(:current_square) { 'e8' }
      let(:king) { described_class.new(color, current_square) }

      before { king.instance_variable_set(:@player, player) }

      context 'when legal moves are [d8, f8, g8, f7]' do
        let(:legal_moves) { %w[d8 f8 g8 f7] }

        context 'if king is not in check at e8 but
            opponent queen is at e6 attacking square g8' do
          it 'returns array of squares: d8, f8' do
            opponent = Queen.new(opponent_color, 'e6')

            board = { 'e8' => king,
                      'h8' => double('Rook', color: color),
                      'f8' => ' ',
                      'f7' => ' ',
                      'g8' => ' ',
                      'e6' => opponent,
                      'e7' => double(color: color),
                      'd8' => ' ',
                      'd7' => ' ' }

            expected_array = %w[d8 f8]

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe King do
  let!(:setup) { KingMovement.set_up }
  let!(:setup_queen) { QueenMovement.set_up }

  context 'with white kings' do
    it_behaves_like 'a king' do
      let(:color) { 'white' }
      let(:opponent_color) { 'black' }
    end
  end

  context 'with black kings' do
    it_behaves_like 'a king' do
      let(:color) { 'black' }
      let(:opponent_color) { 'white' }
    end
  end
end
