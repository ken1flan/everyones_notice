# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  summary    :string           not null
#  body       :text             not null
#  started_on :date             not null
#  ended_on   :date             not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_advertisements_on_started_on_and_ended_on  (started_on,ended_on)
#  index_advertisements_on_updated_at               (updated_at)
#

require 'test_helper'

describe Advertisement do
  describe 'バリデーション' do
    before { @advertisement = build(:advertisement) }

    describe 'title' do
      valid_data = [1, 2, 'a', 'aaa', 'あああ', 'あ' * 64]
      valid_data.each do |vd|
        context "title = #{vd}のとき" do
          before { @advertisement.title = vd }

          it 'validであること' do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '', 'あ' * 65]
      invalid_data.each do |ivd|
        context "title = #{ivd}のとき" do
          before { @advertisement.title = ivd }

          it 'invalidであること' do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe 'summary' do
      valid_data = [1, 2, 'a', 'aaa', 'あああ', 'あ' * 255]
      valid_data.each do |vd|
        context "summary = #{vd}のとき" do
          before { @advertisement.summary = vd }

          it 'validであること' do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '', 'あ' * 256]
      invalid_data.each do |ivd|
        context "summary = #{ivd}のとき" do
          before { @advertisement.summary = ivd }

          it 'invalidであること' do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe 'body' do
      valid_data = [1, 2, 'a', 'aaa', 'あああ']
      valid_data.each do |vd|
        context "body = #{vd}のとき" do
          before { @advertisement.body = vd }

          it 'validであること' do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '']
      invalid_data.each do |ivd|
        context "body = #{ivd}のとき" do
          before { @advertisement.body = ivd }

          it 'invalidであること' do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end

    describe 'started_on' do
      valid_data = ['2014/01/01', '2015-12-31', '2016/2/29']
      valid_data.each do |vd|
        context "started_on = #{vd}のとき" do
          before { @advertisement.started_on = vd }

          it 'validであること' do
            @advertisement.valid?.must_equal true
          end
        end
      end

      invalid_data = [nil, '', 'aaa', 'あああ', '2015/2/29']
      invalid_data.each do |ivd|
        context "started_on = #{ivd}のとき" do
          before { @advertisement.started_on = ivd }

          it 'invalidであること' do
            @advertisement.invalid?.must_equal true
          end
        end
      end
    end
  end

  describe 'scope' do
    describe '#displayable' do
      context 'started_on = 2日前 かつ ended_on = 1日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 2.days.ago,
            ended_on: 1.day.ago
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 1日前 かつ ended_on = 2日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 1.days.ago,
            ended_on: 2.day.ago
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 1日前 かつ ended_on = 1日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 1.days.ago,
            ended_on: 1.day.ago
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 1日前 かつ ended_on = 0日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 1.days.ago,
            ended_on: 0.day.ago
          )
        end

        it '選択されること' do
          Advertisement.displayable.first.must_equal @advertisement
        end
      end

      context 'started_on = 0日前 かつ ended_on = 1日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 0.days.ago,
            ended_on: 1.day.ago
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 0日前 かつ ended_on = 0日前のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 0.days.ago,
            ended_on: 0.day.ago
          )
        end

        it '選択されること' do
          Advertisement.displayable.first.must_equal @advertisement
        end
      end

      context 'started_on = 0日前 かつ ended_on = 1日後のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 0.days.ago,
            ended_on: 1.days.since
          )
        end

        it '選択されること' do
          Advertisement.displayable.first.must_equal @advertisement
        end
      end

      context 'started_on = 1日後 かつ ended_on = 1日後のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 1.days.since,
            ended_on: 1.days.since
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 1日後 かつ ended_on = 2日後のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 1.days.since,
            ended_on: 2.days.since
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end

      context 'started_on = 2日後 かつ ended_on = 1日後のとき' do
        before do
          @advertisement = create(
            :advertisement,
            started_on: 2.days.since,
            ended_on: 1.days.since
          )
        end

        it '選択されないこと' do
          Advertisement.displayable.blank?.must_equal true
        end
      end
    end
  end

  describe '#register_activity' do
    context 'advertisementをcreateしたとき' do
      before do
        @advertisement = create(:advertisement)
        @activity_count = Activity.count
        @activity = Activity.find_by(type_id: Activity.type_ids[:advertisement], advertisement_id: @advertisement.id)
      end

      it 'Activityにユーザが登録されていること' do
        @activity.user_id.must_equal @advertisement.user_id
      end

      context 'advertisementを更新したとき' do
        before { @advertisement.update_attributes(body: '更新内容') }

        it 'Activityのレコード数が変わっていないこと' do
          Activity.count.must_equal @activity_count
        end

        it 'activityの内容が更新されていないこと' do
          Activity.find_by(type_id: Activity.type_ids[:advertisement], advertisement_id: @advertisement.id).must_equal @activity
        end
      end
    end
  end
end
