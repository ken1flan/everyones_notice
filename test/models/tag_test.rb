# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

describe Tag do
  describe 'バリデーション' do
    before { @tag = build(:tag) }

    describe 'name' do
      valid_data = [1, 2, 'a', 'あ', 'あ' * 32]
      valid_data.each do |vd|
        context "title = #{vd}のとき" do
          before { @tag.name = vd }

          it 'validであること' do
            @tag.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '', 'あ,あ', 'あ' * 33]
      invalid_data.each do |ivd|
        context "title = #{ivd}のとき" do
          before { @tag.name = ivd }

          it 'invalidであること' do
            @tag.invalid?.must_equal true
          end
        end
      end
    end
  end
end
