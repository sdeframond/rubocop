# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Rails::FindEach do
  subject(:cop) { described_class.new }

  shared_examples 'register_offense' do |scope|
    it "when using #{scope}.each" do
      inspect_source(cop, "User.#{scope}.each { |u| u.something }")

      expect(cop.messages)
        .to eq(['Use `find_each` instead of `each`.'])
    end
  end

  it_behaves_like('register_offense', 'where(name: name)')
  it_behaves_like('register_offense', 'all')

  it 'does not registers an offense when using find_by' do
    inspect_source(cop, 'User.all.find_each { |u| u.x }')

    expect(cop.messages).to be_empty
  end

  it 'auto-corrects each to find_each' do
    new_source = autocorrect_source(
      cop,
      'User.all.each { |u| u.x }'
    )

    expect(new_source).to eq('User.all.find_each { |u| u.x }')
  end
end
