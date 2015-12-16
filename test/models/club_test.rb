# == Schema Information
#
# Table name: clubs
#
#  id          :integer          not null, primary key
#  name        :string(128)      not null
#  slug        :string(64)       not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

describe Club do
  describe ".activities_for_heatmap" do
    before do
      @club = create(:club)
      @users = create_list(:user, 2, club_id: @club.id)
      @user = @users.first
      Notice.skip_callback(:save, :after, :register_activity)
      Reply.skip_callback(:save, :after, :register_activity)
      Timecop.freeze
    end

    [:notice, :reply].each do |activity_type|
      context "#{activity_type}がないとき" do
        it "nilであること" do
          @heatmap = @club.activities_for_heatmap
          JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
        end
      end

      context "現在が2014/11/29 09:04:12 のとき" do
        before do
          @now = Time.local(2014, 11, 29, 9, 4, 12)
          Timecop.travel @now
        end

        context "2014/05/31 23:59:59に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 5, 31, 23, 59, 59)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "nilであること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end

        context "2014/06/01 00:00:00に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "1であること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 1
          end
        end

        context "2014/11/29 09:04:12に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 11, 29, 9, 4, 12)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "1であること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 1
          end
        end

        context "2014/11/29 09:04:13に#{activity_type}が1件あったとき" do
          before do
            @created_at = Time.local(2014, 11, 29, 9, 4, 13)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user.id, created_at: @created_at)
          end

          it "nilであること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end

        context "2014/06/01 00:00:00に#{activity_type}が2件あったとき" do
          before do
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            @users.each do |user|
              create(:activity, type_id: Activity.type_ids[activity_type], user: user, created_at: @created_at)
            end
          end
 
          it "2であること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal 2
          end
        end

        context "2014/06/01 00:00:00に他のclubユーザの#{activity_type}が1件あったとき" do
          before do
            @club_another = create(:club)
            @user_club_another = create(:user, club_id: @club_another.id)
            @created_at = Time.local(2014, 6, 1, 0, 0, 0)
            create(:activity, type_id: Activity.type_ids[activity_type], user_id: @user_club_another.id, created_at: @created_at)
          end
 
          it "nilであること" do
            @heatmap = @club.activities_for_heatmap
            JSON.parse(@heatmap)[@created_at.to_i.to_s].must_equal nil
          end
        end
      end
    end

    after do
      Notice.set_callback(:save, :after, :register_activity)
      Reply.set_callback(:save, :after, :register_activity)
      Timecop.return
    end
  end
end
