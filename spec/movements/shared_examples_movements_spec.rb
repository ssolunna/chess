# frozen_string_literal: true

RSpec.shared_examples "saves layout" do |initial_value|
  let(:movements) { described_class.class_variable_get(:@@movements) }

  it 'saves the layout in a @@movements class variable' do
    layout = described_class.lay_out

    described_class.class_variable_set(:@@movements, initial_value)

    expect { described_class.lay_out }.to \
      change { movements }
      .from(initial_value)
      .to(layout)
  end
end
