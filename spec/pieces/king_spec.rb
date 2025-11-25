# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/player'

RSpec.shared_examples 'a king' do
  describe '#search_legal_moves' do
    context 'without castling moves available' do
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
      context 'when king at e1, rooks at a1 and h1
          and same color pieces at d2, e2, f2' do
        let(:current_square) { 'e1' }
        let(:rook_at_square) { 'a1' }
        let(:second_rook_at_square) { 'h1' }

        let(:rook) { Rook.new(color, rook_at_square, player) }

        let(:second_rook) { Rook.new(color, second_rook_at_square, player) }

        let(:board) do
          { rook_at_square => rook,
            'b1' => ' ',
            'c1' => ' ',
            'd1' => ' ',
            current_square => king,
            'f1' => ' ',
            'g1' => ' ',
            second_rook_at_square => second_rook,
            'd2' => Pawn.new(color, 'd2'),
            'e2' => Pawn.new(color, 'e2'),
            'f2' => Pawn.new(color, 'f2'),
            'a8' => Rook.new(opponent_color, 'a8', opponent_player),
            'b8' => ' ',
            'c8' => ' ',
            'd8' => ' ',
            'e8' => King.new(opponent_color, 'e8', opponent_player),
            'f8' => ' ',
            'g8' => ' ',
            'h8' => Rook.new(opponent_color, 'h8', opponent_player) }
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

          context 'if king is in check by knight at c2' do
            it 'returns an array of squares d1, f1' do
              opponent = Knight.new(opponent_color, 'c2', opponent_player)

              board['c2'] = opponent

              expected_array = %w[d1 f1]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if king is not in check by knight at e3' do
            it 'returns an array of squares: d1 f1' do
              opponent = Knight.new(opponent_color, 'e3', opponent_player)

              board['e3'] = opponent

              expected_array = %w[d1 f1]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking square f1' do
            it 'returns an array of squares d1, c1, f1' do
              opponent = Knight.new(opponent_color, 'g3', opponent_player)

              board['g3'] = opponent

              expected_array = %w[d1 c1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking square c1' do
            it 'returns an array of squares d1, f1, g1' do
              opponent = Knight.new(opponent_color, 'b3', opponent_player)

              board['b3'] = opponent

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking squares e1 c1' do
            it 'returns an array of squares d1, f1' do
              opponent = Knight.new(opponent_color, 'd3', opponent_player)

              board['d3'] = opponent

              expected_array = %w[d1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking squares e1 g1' do
            it 'returns an array of squares d1, f1' do
              opponent = Knight.new(opponent_color, 'f3', opponent_player)

              board['f3'] = opponent

              expected_array = %w[f1 d1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          %w[b1 c1 d1].each do |square|
            context "if there is an opponent piece at #{square}" do
              it 'returns an array including g1 but not c1' do
                opponent = Knight.new(opponent_color, square, opponent_player)

                board[square] = opponent

                expect(king.search_legal_moves(board)).to include('g1')
                expect(king.search_legal_moves(board)).not_to include('c1')
              end
            end
          end

          %w[f1 g1].each do |square|
            context "if there is a same-color piece at #{square}" do
              it 'returns an array including c1 but not g1' do
                piece = Knight.new(color, square, opponent_player)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('c1')
                expect(king.search_legal_moves(board)).not_to include('g1')
              end
            end
          end

          context 'if there are opponent pieces at d1 and f1' do
            it 'returns an array not including c1, g1' do
              piece = Rook.new(opponent_color, 'd1', opponent_player)
              second_piece = Rook.new(opponent_color, 'f1', opponent_player)

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

          context 'if rook at a1 moves, but king does not' do
            it 'returns an array of squares d1 f1 g1' do
              allow(rook).to receive(:moves_log).and_return([rook_at_square, 'a2'])

              board['a2'] = rook
              board[rook_at_square] = ' '

              expected_array = %w[d1 f1 g1]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h1 moves, but king does not' do
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
              player.pieces.delete(rook)

              board[rook_at_square] = ' '

              expected_array = %w[d1 f1 g1]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at h1' do
            it 'returns an array of squares d1 f1 c1' do
              player.pieces.delete(second_rook)

              board[second_rook_at_square] = ' '

              expected_array = %w[d1 f1 c1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there are no rooks' do
            it 'returns an array of squares d1 f1' do
              player.pieces.delete(rook)
              player.pieces.delete(second_rook)

              board[rook_at_square] = ' '
              board[second_rook_at_square] = ' '

              expected_array = %w[d1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if opponent king is attacking squares b1 c1 d1' do
            it 'returns an array of squares d1 f1 g1' do
              opp_king = King.new(opponent_color, 'c2', opponent_player)
              allow(opp_king).to receive(:moves_log).and_return(['e8', opp_king.current_square])

              board['e8'] = ' '
              board['c2'] = opp_king

              expected_array = %w[d1 f1 g1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if opponent king is attacking squares e1 f1 g1' do
            it 'returns an array of squares f2 d1 f1' do
              opp_king = King.new(opponent_color, 'f2', opponent_player)
              allow(opp_king).to receive(:moves_log).and_return(['e8', opp_king.current_square])

              board['e8'] = ' '
              board['f2'] = opp_king

              expected_array = %w[f2 d1 f1]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end
        end
      end

      context 'when king at e8, rooks at a8 and h8
          and same color pieces at d7, e7, f7' do
        let(:current_square) { 'e8' }
        let(:rook_at_square) { 'a8' }
        let(:second_rook_at_square) { 'h8' }

        let(:rook) { Rook.new(color, rook_at_square, player) }

        let(:second_rook) { Rook.new(color, second_rook_at_square, player) }

        let(:board) do
          { rook_at_square => rook,
            'b8' => ' ',
            'c8' => ' ',
            'd8' => ' ',
            current_square => king,
            'f8' => ' ',
            'g8' => ' ',
            second_rook_at_square => second_rook,
            'd7' => Pawn.new(color, 'd7'),
            'e7' => Pawn.new(color, 'e7'),
            'f7' => Pawn.new(color, 'f7'),
            'a1' => Rook.new(opponent_color, 'a1', opponent_player),
            'b1' => ' ',
            'c1' => ' ',
            'd1' => ' ',
            'e1' => King.new(opponent_color, 'e1', opponent_player),
            'f1' => ' ',
            'g1' => ' ',
            'h1' => Rook.new(opponent_color, 'h1', opponent_player) }
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

          context 'if king is in check by knight at c7' do
            it 'returns an array of squares d8, f8' do
              opponent = Knight.new(opponent_color, 'c7', opponent_player)

              board['c7'] = opponent

              expected_array = %w[d8 f8]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if king is not in check by knight at e6' do
            it 'returns an array of squares: d8 f8' do
              opponent = Knight.new(opponent_color, 'e6', opponent_player)

              board['e6'] = opponent

              expected_array = %w[d8 f8]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking square f8' do
            it 'returns an array of squares d8, c8, f8' do
              opponent = Knight.new(opponent_color, 'g6', opponent_player)

              board['g6'] = opponent

              expected_array = %w[d8 c8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking square c8' do
            it 'returns an array of squares d8, f8, g8' do
              opponent = Knight.new(opponent_color, 'b6', opponent_player)

              board['b6'] = opponent

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking squares e8 c8' do
            it 'returns an array of squares d8, f8' do
              opponent = Knight.new(opponent_color, 'd6', opponent_player)

              board['d6'] = opponent

              expected_array = %w[d8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if knight is attacking squares e8 g8' do
            it 'returns an array of squares d8, f8' do
              opponent = Knight.new(opponent_color, 'f6', opponent_player)

              board['f6'] = opponent

              expected_array = %w[f8 d8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          %w[b8 c8 d8].each do |square|
            context "if there is an opponent piece at #{square}" do
              it 'returns an array including g8 but not c8' do
                opponent = Knight.new(opponent_color, square, opponent_player)

                board[square] = opponent

                expect(king.search_legal_moves(board)).to include('g8')
                expect(king.search_legal_moves(board)).not_to include('c8')
              end
            end
          end

          %w[f8 g8].each do |square|
            context "if there is a same-color piece at #{square}" do
              it 'returns an array including c8 but not g8' do
                piece = Knight.new(color, square, opponent_player)

                board[square] = piece

                expect(king.search_legal_moves(board)).to include('c8')
                expect(king.search_legal_moves(board)).not_to include('g8')
              end
            end
          end

          context 'if there are opponent pieces at d8 and f8' do
            it 'returns an array not including c8, g8' do
              piece = Rook.new(opponent_color, 'd8', opponent_player)
              second_piece = Rook.new(opponent_color, 'f8', opponent_player)

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

          context 'if rook at a8 moves, but king does not' do
            it 'returns an array of squares d8 f8 g8' do
              allow(rook).to receive(:moves_log).and_return([rook_at_square, 'a7'])

              board['a7'] = rook
              board[rook_at_square] = ' '

              expected_array = %w[d8 f8 g8]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if rook at h8 moves, but king does not' do
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
              player.pieces.delete(rook)

              board[rook_at_square] = ' '

              expected_array = %w[d8 f8 g8]

              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there is no rook at h8' do
            it 'returns an array of squares d8 f8 c8' do
              player.pieces.delete(second_rook)

              board[second_rook_at_square] = ' '

              expected_array = %w[d8 f8 c8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if there are no rooks' do
            it 'returns an array of squares d8 f8' do
              player.pieces.delete(rook)
              player.pieces.delete(second_rook)

              board[rook_at_square] = ' '
              board[second_rook_at_square] = ' '

              expected_array = %w[d8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if opponent king is attacking squares b8 c8 d8' do
            it 'returns an array of squares d8 f8 g8' do
              opp_king = King.new(opponent_color, 'c7', opponent_player)
              allow(opp_king).to receive(:moves_log).and_return(['e8', opp_king.current_square])

              board['e1'] = ' '
              board['c7'] = opp_king

              expected_array = %w[d8 f8 g8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end

          context 'if opponent king is attacking squares e8 f8 g8' do
            it 'returns an array of squares f7 d8 f8' do
              opp_king = King.new(opponent_color, 'f7', opponent_player)
              allow(opp_king).to receive(:moves_log).and_return(['e8', opp_king.current_square])

              board['e1'] = ' '
              board['f7'] = opp_king

              expected_array = %w[f7 d8 f8]
              expect(king.search_legal_moves(board)).to match_array(expected_array)
            end
          end
        end
      end
    end
  end

  describe '#screen_legal_moves' do
    context 'when king is at f4' do
      let(:current_square) { 'f4' }

      context 'when legal moves are [e5, f5, g5, g4, g3, f3, e3, e4]' do
        let(:legal_moves) { %w[e5 f5 g5 g4 g3 f3 e3 e4] }

        context 'if king in check by bishop at d6
            attacking squares: e5 f4 g3' do
          let(:opponent_square) { 'd6' }
          let(:opponent) { Bishop.new(opponent_color, opponent_square, player) }

          it 'returns array of squares: f5, g5, g4, f3, e3, e4' do
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

        context 'if king at check by queen at f5
            attacking squares: f4 f3 g4 g5 e5 e4' do
          let(:opponent_square) { 'f5' }
          let(:opponent) { Queen.new(opponent_color, opponent_square, player) }

          it 'returns array of squares: f5 e3 g3' do
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

        context 'if king is not in check by queens:
            at d5 attacking squares e5 f5 g5 e4 f3, and
            at g6 attacking squares g5 g4 g3 f5 e4' do
          let(:opponent_square) { 'd5' }
          let(:second_opponent_square) { 'g6' }
          let(:opponent) { Queen.new(opponent_color, opponent_square, player) }
          let(:opponent_two) { Queen.new(opponent_color, second_opponent_square, player) }

          it 'returns array of squares: e3' do
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

        context 'if king is in check by queen at g5
            attacking squares f5 f4 e3 g4 g3' do
          let(:opponent_square) { 'g5' }
          let(:opponent) { Queen.new(opponent_color, opponent_square, player) }

          it 'returns array of squares: e5, g5, f3, e4' do
            board = { 'f4' => king,
                      'e5' => ' ',
                      'f5' => Pawn.new(color, 'f5'),
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

        context 'if king is not check by rook at c2
            attacking squares b2 a2, or by second rook
            at b4 attacking squares b3 b2 b1' do
          let(:opponent_square) { 'c2' }
          let(:second_opponent_square) { 'b4' }
          let(:opponent) { Rook.new(opponent_color, opponent_square, player) }
          let(:opponent_two) { Rook.new(opponent_color, second_opponent_square, player) }

          it 'returns an empty array' do
            board = { 'c2' => opponent,
                      'b4' => opponent_two,
                      'a1' => king,
                      'a2' => ' ',
                      'a3' => ' ',
                      'b3' => ' ',
                      'b2' => ' ',
                      'b1' => ' ' }

            selected_legal_moves = king.screen_legal_moves(legal_moves, board)

            expect(selected_legal_moves).to be_empty
          end
        end
      end

      context 'when legal moves are [b1]' do
        let(:legal_moves) { %w[b1] }

        context 'if king is not in check by king at c2
            attacking squares b2 c1 b1' do
          let(:opponent_square) { 'c2' }
          let(:opponent) { King.new(opponent_color, opponent_square, player) }

          it 'returns an empty array' do
            board = { 'c2' => opponent,
                      'a1' => king,
                      'a2' => Pawn.new(color, 'a2'),
                      'a3' => ' ',
                      'b2' => Pawn.new(color, 'b2'),
                      'c1' => Pawn.new(color, 'c1'),
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

        context 'if king is not in check but queen at e6
            attacking squares g8 c8 e7 d7 f7' do
          let(:opponent_square) { 'e6' }
          let(:opponent) { Queen.new(opponent_color, opponent_square, player) }

          it 'returns array of squares: d8, f8' do
            board = { 'e8' => king,
                      'h8' => Rook.new(color, 'h8', player),
                      'f8' => ' ',
                      'f7' => ' ',
                      'g8' => ' ',
                      'e6' => opponent,
                      'e7' => Pawn.new(color, 'e7'),
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
  KingMovement.set_up
  KnightMovement.set_up

  let(:player) { Player.new(color, {}) }
  let(:opponent_player) { Player.new(opponent_color, {}) }
  let(:king) { described_class.new(color, current_square, player) }

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
