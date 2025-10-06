# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/player'

RSpec.shared_examples 'a king' do
  describe '#search_legal_moves' do
    let(:player) { Player.new(color, {}) }
    let(:king) { described_class.new(color, current_square, player) }

    context 'without castling moves available' do
      before do
        king.instance_variable_set(:@moves, king.moves_from(current_square))
      end

      context 'when king is at e1 (but no rooks)' do
        let(:current_square) { 'e1' }

        context 'if d2 empty, same-color at d1, e2, f1 and opponent at f2' do
          it 'returns array of squares: d2, f2' do
            board = { 'd2' => ' ',
                      'e2' => double(color: color),
                      'f2' => double(color: opponent_color),
                      'd1' => double(color: color),
                      'f1' => double(color: color) }
            expected_array = %w[d2 f2]

            legal_moves = king.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when king is at e8 (but no rooks)' do
        let(:current_square) { 'e8' }

        context 'if d7, f7 empty, same-color piece at e7 and opponent at d8, f8' do
          it 'returns array of squares: d7, f7, d8, f8' do
            board = { 'e7' => double(color: color),
                      'd7' => ' ',
                      'f7' => ' ',
                      'd8' => double(color: opponent_color),
                      'f8' => double(color: opponent_color) }
            expected_array = %w[d7 f7 d8 f8]

            legal_moves = king.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when king is at a8' do
        let(:current_square) { 'a8' }

        context 'if b8 empty, same-color at b7 and opponent at a7' do
          it 'returns array of squares: b8, a7' do
            board = { 'b7' => double(color: color),
                      'b8' => ' ',
                      'a7' => double(color: opponent_color) }

            expected_array = %w[b8 a7]

            legal_moves = king.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end

      context 'when king is at h1' do
        let(:current_square) { 'h1' }

        context 'if same-color pieces at g1, g2, h2' do
          it 'returns an empty array' do
            board = { 'g1' => double(color: color),
                      'g2' => double(color: color),
                      'h2' => double(color: color) }

            legal_moves = king.search_legal_moves(board)

            expect(legal_moves).to be_empty
          end
        end
      end

      context 'when king is at e5' do
        let(:current_square) { 'e5' }

        context 'if e6, f5, f4, d6 empty, same-color at d5, f6
            and opponent at e4, d4' do
          it 'returns array of squares: e6, f5, f4, d6, e4, d4' do
            board = { 'd6' => ' ',
                      'e6' => ' ',
                      'f6' => double(color: color),
                      'f5' => ' ',
                      'f4' => ' ',
                      'e4' => double(color: opponent_color),
                      'd4' => double(color: opponent_color),
                      'd5' => double(color: color) }

            expected_array = %w[e6 f5 f4 d6 e4 d4]

            legal_moves = king.search_legal_moves(board)

            expect(legal_moves).to match_array(expected_array)
          end
        end
      end
    end

    context 'with castling moves available' do
      context 'when white king at e1, white rooks at a1 and h1
          and same color pieces at d2, e2, f2' do
        let(:current_square) { 'e1' }
        let(:rook_at_square) { 'a1' }
        let(:second_rook_at_square) { 'h1' }

        let(:opponent) { described_class.new(opponent_color, '') }
        let(:rook) do
          double('Rook', color: color,
                         current_square: rook_at_square,
                         player: player,
                         moves_log: [rook_at_square])
        end

        let(:second_rook) do
          double('2Rook', color: color,
                          current_square: second_rook_at_square,
                          player: player,
                          moves_log: [second_rook_at_square])
        end

        let(:board) do
          { rook_at_square => rook,
            'b1' => ' ',
            'c1' => ' ',
            'd1' => ' ',
            current_square => king,
            'f1' => ' ',
            'g1' => ' ',
            second_rook_at_square => second_rook,
            'd2' => double(color: color),
            'e2' => double(color: color),
            'f2' => double(color: color) }
        end

        before do
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          player.instance_variable_set(:@pieces, [king, rook, second_rook])
          allow(rook).to receive(:class) { Rook }
          allow(second_rook).to receive(:class) { Rook }
        end

        context 'if castling conditions are met for both rooks' do
          it 'returns an array of squares d1, f1, c1, g1' do
            expected_array = %w[d1 f1 c1 g1]
            expect(king.search_legal_moves(board)).to match_array(expected_array)
          end
        end

        context 'when a castling condition is not met' do
          context 'if king has previously made a move' do
            it 'returns an array not including c1, g1' do
              king.instance_variable_set(:@moves_log, [current_square, 'e2', current_square])

              expect(king.search_legal_moves(board)).not_to include('c1', 'g1')
            end
          end

          context 'if rook at a1 has previously made a move' do
            it 'returns an array of squares d1, f1, g1' do
              allow(rook).to receive(:moves_log)
                .and_return([rook_at_square, 'a2', rook_at_square])

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h1 has previously made a move' do
            it 'returns an array of squares d1, f1, c1' do
              allow(second_rook).to receive(:moves_log)
                .and_return([second_rook_at_square, 'h2', second_rook_at_square])

              expected_array = %w[d1 f1 c1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if king is in check' do
            it 'returns an array of squares d1, f1' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return([current_square])

              board['c2'] = opponent

              expected_array = %w[d1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square d1' do
            it 'returns an array of squares d1, f1, g1' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['d1'])

              board['e3'] = opponent

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square f1' do
            it 'returns an array of squares d1, c1, f1' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['f1'])

              board['g3'] = opponent

              expected_array = %w[d1 c1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square c1' do
            it 'returns an array of squares d1, f1, g1' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['c1'])

              board['d3'] = opponent

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square g1' do
            it 'returns an array of squares d1, c1, f1' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['g1'])

              board['f3'] = opponent

              expected_array = %w[d1 c1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          %w[b1 c1 d1].each do |square|
            context "if there is a piece at #{square}" do
              it 'returns an array including g1 but not c1' do
                piece = double(color: opponent_color,
                               current_square: square,
                               gives_check?: false,
                               attacking_square?: false)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('g1')
                expect(king.search_legal_moves(board)).not_to include('c1')
              end
            end
          end

          %w[f1 g1].each do |square|
            context "if there is a piece at #{square}" do
              it 'returns an array including c1 but not g1' do
                piece = double(color: opponent_color,
                               current_square: square,
                               gives_check?: false,
                               attacking_square?: false)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('c1')
                expect(king.search_legal_moves(board)).not_to include('g1')
              end
            end
          end

          context 'if there are pieces at d1 and f1' do
            it 'returns an array not including c1, g1' do
              piece = double(color: opponent_color,
                             current_square: 'd1',
                             gives_check?: false,
                             attacking_square?: false)

              second_piece = double(color: opponent_color,
                                    current_square: 'f1',
                                    gives_check?: false,
                                    attacking_square?: false)

              board['d1'] = piece
              board['f1'] = second_piece

              expect(king.search_legal_moves(board)).not_to include('c1', 'g1')
            end
          end

          context 'if king moves, but rooks do not' do
            it 'returns an array not including c1, g1' do
              king.instance_variable_set(:@moves_log, [current_square, 'e2'])

              board['e2'] = king
              board[current_square] = ' '

              expect(king.search_legal_moves(board)).not_to include('c1', 'g1')
            end
          end

          context 'if rook at a1 moves, but king do not' do
            it 'returns an array of squares d1 f1 g1' do
              allow(rook).to receive(:moves_log).and_return([rook_at_square, 'a2'])

              board['a2'] = rook
              board[rook_at_square] = ' '

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h1 moves, but king do not' do
            it 'returns an array of squares d1 f1 c1' do
              allow(second_rook).to receive(:moves_log).and_return([second_rook_at_square, 'h2'])

              board['h2'] = second_rook
              board[second_rook_at_square] = ' '

              expected_array = %w[d1 f1 c1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at a1' do
            it 'returns an array of squares d1 f1 g1' do
              allow(player).to receive(:pieces) { [king, second_rook] }

              board[rook_at_square] = ' '

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at h1' do
            it 'returns an array of squares d1 f1 c1' do
              allow(player).to receive(:pieces) { [king, rook] }

              board[second_rook_at_square] = ' '

              expected_array = %w[d1 f1 c1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook' do
            it 'returns an array of squares d1 f1' do
              allow(player).to receive(:pieces) { [king] }

              board[rook_at_square] = ' '
              board[second_rook_at_square] = ' '

              expected_array = %w[d1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end
        end
      end

      context 'when king at e8, white rooks at a8 and h8
          and same color pieces at d7, e7, f7' do
        let(:current_square) { 'e8' }
        let(:rook_at_square) { 'a8' }
        let(:second_rook_at_square) { 'h8' }

        let(:opponent) { described_class.new(opponent_color, '') }

        let(:rook) do
          double('Rook', color: color,
                         current_square: rook_at_square,
                         player: player,
                         moves_log: [rook_at_square])
        end

        let(:second_rook) do
          double('2Rook', color: color,
                          current_square: second_rook_at_square,
                          player: player,
                          moves_log: [second_rook_at_square])
        end

        let(:board) do
          { rook_at_square => rook,
            'b8' => ' ',
            'c8' => ' ',
            'd8' => ' ',
            current_square => king,
            'f8' => ' ',
            'g8' => ' ',
            second_rook_at_square => second_rook,
            'd7' => double(color: color),
            'e7' => double(color: color),
            'f7' => double(color: color) }
        end

        before do
          king.instance_variable_set(:@moves, king.moves_from(current_square))
          player.instance_variable_set(:@pieces, [king, rook, second_rook])
          allow(rook).to receive(:class) { Rook }
          allow(second_rook).to receive(:class) { Rook }
        end

        context 'if castling conditions are met for both rooks' do
          it 'returns an array of squares d8, f8, c8, g8' do
            expected_array = %w[d8 f8 c8 g8]
            expect(king.search_legal_moves(board)).to match_array(expected_array)
          end
        end

        context 'when a castling condition is not met' do
          context 'if king has previously made a move' do
            it 'returns an array not including c8, g8' do
              king.instance_variable_set(:@moves_log, [current_square, 'e7', current_square])

              expect(king.search_legal_moves(board)).not_to include('c8', 'g8')
            end
          end

          context 'if rook at a8 has previously made a move' do
            it 'returns an array of squares d8, f8, g8' do
              allow(rook).to receive(:moves_log)
                .and_return([rook_at_square, 'a7', rook_at_square])

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h8 has previously made a move' do
            it 'returns an array of squares d8, f8, c8' do
              allow(second_rook).to receive(:moves_log)
                .and_return([second_rook_at_square, 'h7', second_rook_at_square])

              expected_array = %w[d8 f8 c8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if king is in check' do
            it 'returns an array of squares d8, f8' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return([current_square])

              board['c7'] = opponent

              expected_array = %w[d8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square d8' do
            it 'returns an array of squares d8, f8, g8' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['d8'])

              board['e6'] = opponent

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square f8' do
            it 'returns an array of squares d8, c8, f8' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['f8'])

              board['g6'] = opponent

              expected_array = %w[d8 c8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square c8' do
            it 'returns an array of squares d8, f8, g8' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['c8'])

              board['d6'] = opponent

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if an opponent is attacking square g8' do
            it 'returns an array of squares d8, c8, f8' do
              allow(opponent).to receive(:search_legal_moves)
                .and_return(['g8'])

              board['f6'] = opponent

              expected_array = %w[d8 c8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          %w[b8 c8 d8].each do |square|
            context "if there is a piece at #{square}" do
              it 'returns an array including g8 but not c8' do
                piece = double(color: opponent_color,
                               current_square: square,
                               gives_check?: false,
                               attacking_square?: false)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('g8')
                expect(king.search_legal_moves(board)).not_to include('c8')
              end
            end
          end

          %w[f8 g8].each do |square|
            context "if there is a piece at #{square}" do
              it 'returns an array including c8 but not g8' do
                piece = double(color: opponent_color,
                               current_square: square,
                               gives_check?: false,
                               attacking_square?: false)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('c8')
                expect(king.search_legal_moves(board)).not_to include('g8')
              end
            end
          end

          context 'if there are pieces at d8 and f8' do
            it 'returns an array not including c8, g8' do
              piece = double(color: opponent_color,
                             current_square: 'd8',
                             gives_check?: false,
                             attacking_square?: false)

              second_piece = double(color: opponent_color,
                                    current_square: 'f8',
                                    gives_check?: false,
                                    attacking_square?: false)

              board['d8'] = piece
              board['f8'] = second_piece

              expect(king.search_legal_moves(board)).not_to include('c8', 'g8')
            end
          end

          context 'if king moves, but rooks do not' do
            it 'returns an array not including c8, g8' do
              king.instance_variable_set(:@moves_log, [current_square, 'e7'])

              board['e7'] = king
              board[current_square] = ' '

              expect(king.search_legal_moves(board)).not_to include('c8', 'g8')
            end
          end

          context 'if rook at a8 moves, but king do not' do
            it 'returns an array of squares d8 f8 g8' do
              allow(rook).to receive(:moves_log).and_return([rook_at_square, 'a7'])

              board['a7'] = rook
              board[rook_at_square] = ' '

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h8 moves, but king do not' do
            it 'returns an array of squares d8 f8 c8' do
              allow(second_rook).to receive(:moves_log).and_return([second_rook_at_square, 'h7'])

              board['h7'] = second_rook
              board[second_rook_at_square] = ' '

              expected_array = %w[d8 f8 c8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at a8' do
            it 'returns an array of squares d8 f8 g8' do
              allow(player).to receive(:pieces) { [king, second_rook] }

              board[rook_at_square] = ' '

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at h8' do
            it 'returns an array of squares d8 f8 c8' do
              allow(player).to receive(:pieces) { [king, rook] }

              board[second_rook_at_square] = ' '

              expected_array = %w[d8 f8 c8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook' do
            it 'returns an array of squares d8 f8' do
              allow(player).to receive(:pieces) { [king] }

              board[rook_at_square] = ' '
              board[second_rook_at_square] = ' '

              expected_array = %w[d8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    let(:player) { Player.new(color, {}) }
    let(:king) { described_class.new(color, current_square, player) }
    let(:opponent) { described_class.new(opponent_color, opponent_square, player) }
    let(:opponent_two) { described_class.new(opponent_color, second_opponent_square, player) }

    context 'when king is at f4' do
      let(:current_square) { 'f4' }

      context 'when legal moves are [e5, f5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 f5 g5 g4 g3 f3 e3 e4] }

        context 'if king in check by opponent at d6
            attacking squares: e5 f4 g3' do
          let(:opponent_square) { 'd6' }

          it 'returns array of squares: f5, g5, g4, f3, e3, e4' do
            allow(opponent).to receive(:search_legal_moves) { %w[e5 f4 g3] }

            board = { 'd6' => opponent,
                      current_square => king,
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

        context 'if king at check by opponent at f5
            attacking squares: f4 f3 g4 g5 e5 e4' do
          let(:opponent_square) { 'f5' }

          it 'returns array of squares: f5 e3 g3' do
            allow(opponent).to receive(:search_legal_moves) { %w[f4 f3 g4 g5 e5 e4] }

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

        context 'if king is not in check by opponents:
            at d5 attacking squares e5 f5 g5 e4 f3, and
            at g6 attacking squares g5 g4 g3 f5 e4' do
          let(:opponent_square) { 'd5' }
          let(:second_opponent_square) { 'g6' }

          it 'returns array of squares: e3' do
            allow(opponent).to receive(:search_legal_moves) { %w[e5 f5 g5 e4 f3] }
            allow(opponent_two).to receive(:search_legal_moves) { %w[g5 g4 g3 f5 e4] }

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

        context 'if king is in check by opponent at g5
            attacking squares f5 f4 e3 g4 g3' do
          let(:opponent_square) { 'g5' }

          it 'returns array of squares: e5, g5, f3, e4' do
            allow(opponent).to receive(:search_legal_moves) { %w[f5 f4 e3 g4 g3] }

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

      context 'when legal moves are [a2, b2, b1]' do
        let(:legal_moves) { %w[a2 b2 b1] }

        context 'if king is not check by opponent at c2
            attacking squares b2 a2, or by second opponent
            at b4 attacking squares b3 b2 b1' do
          let(:opponent_square) { 'c2' }
          let(:second_opponent_square) { 'b4' }

          it 'returns an empty array' do
            allow(opponent).to receive(:search_legal_moves) { %w[a2 b2] }
            allow(opponent_two).to receive(:search_legal_moves) { %w[b3 b2 b1] }

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

        context 'if king is not in check by opponent at c2
            attacking squares b2 c1 b1' do
          let(:opponent_square) { 'c2' }

          it 'returns an empty array' do
            allow(opponent).to receive(:search_legal_moves) { %w[b2 c1 b1] }
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

      context 'when legal moves are [d8, f8, g8, f7]' do
        let(:legal_moves) { %w[d8 f8 g8 f7] }

        context 'if king is not in check but opponent at e6
            attacking squares g8 c8 e7 d7 f7' do
          let(:opponent_square) { 'e6' }

          it 'returns array of squares: d8, f8' do
            allow(opponent).to receive(:search_legal_moves) { %w[g8 c8 e7 d7 f7] }

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

            expect(player).to receive(:castling_move_rook)

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to match_array(expected_array)
          end
        end
      end
    end
  end
end

describe King do
  KingMovement.set_up

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
