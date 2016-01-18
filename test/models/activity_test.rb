# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  type_id          :integer
#  user_id          :integer
#  notice_id        :integer
#  reply_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  advertisement_id :integer
#
# Indexes
#
#  index_activities_on_created_at  (created_at)
#  index_activities_on_notice_id   (notice_id)
#  index_activities_on_reply_id    (reply_id)
#  index_activities_on_type_id     (type_id)
#  index_activities_on_user_id     (user_id)
#  index_activities_unique_key     (type_id,user_id,notice_id,reply_id) UNIQUE
#

require 'test_helper'

describe Activity do
  describe '.related_user' do
    context 'noticeがあるとき' do
      before { @notice = create(:notice) }

      context 'noticeを書いたuserを指定して実行したとき' do
        before { @activities = Activity.related_user(@notice.user) }

        it 'noticeを書いたactivityが選択されること' do
          @activities.first.type_id.must_equal 'notice'
        end
      end

      context 'その他のuserを指定して実行したとき' do
        before { @activities = Activity.related_user(create(:user)) }

        it 'レコードが選択されないこと' do
          @activities.blank?.must_equal true
        end
      end

      context 'noticeにいいねされたとき' do
        before do
          @thumbup_notice_user = create(:user)
          @notice.liked_by(@thumbup_notice_user)
          create(:activity, notice: @notice, type_id: Activity.type_ids['thumbup_notice'], user: @thumbup_notice_user)
        end

        context 'noticeを書いたuserを指定して実行したとき' do
          before { @activities = Activity.related_user(@notice.user) }

          it 'noticeにいいねされたactivityが選択されること' do
            @activities.first.type_id.must_equal 'notice'
            @activities.second.type_id.must_equal 'thumbup_notice'
          end
        end

        context 'その他のuserを指定して実行したとき' do
          before { @activities = Activity.related_user(create(:user)) }

          it 'レコードが選択されないこと' do
            @activities.blank?.must_equal true
          end
        end
      end

      context 'noticeにreplyがあるとき' do
        before { @reply = create(:reply, notice: @notice) }

        context 'noticeを書いたuserを指定して実行したとき' do
          before { @activities = Activity.related_user(@notice.user) }

          it 'replyを書いたactivityが選択されること' do
            @activities.first.type_id.must_equal 'notice'
            @activities.second.type_id.must_equal 'reply'
          end
        end

        context 'replyを書いたuserを指定して実行したとき' do
          before { @activities = Activity.related_user(@reply.user) }

          it 'replyを書いたactivityが選択されること' do
            @activities.first.type_id.must_equal 'reply'
          end
        end

        context 'その他のuserを指定して実行したとき' do
          before { @activities = Activity.related_user(create(:user)) }

          it 'レコードが選択されないこと' do
            @activities.blank?.must_equal true
          end
        end

        context 'replyにいいねされたとき' do
          before do
            @thumbup_reply_user = create(:user)
            @reply.liked_by(@thumbup_reply_user)
            create(:activity, notice: @notice, reply: @reply, type_id: Activity.type_ids['thumbup_reply'], user: @thumbup_reply_user)
          end

          context 'noticeを書いたuserを指定して実行したとき' do
            before { @activities = Activity.related_user(@notice.user) }

            it 'noticeにいいねされたactivityが選択されること' do
              @activities.first.type_id.must_equal 'notice'
              @activities.second.type_id.must_equal 'reply'
              @activities.third.type_id.must_equal 'thumbup_reply'
            end
          end

          context 'replyを書いたuserを指定して実行したとき' do
            before { @activities = Activity.related_user(@reply.user) }

            it 'replyにいいねされたactivityが選択されること' do
              @activities.first.type_id.must_equal 'reply'
              @activities.second.type_id.must_equal 'thumbup_reply'
            end
          end

          context 'replyにいいねしたuserを指定して実行したとき' do
            before { @activities = Activity.related_user(@thumbup_reply_user) }

            it 'replyにいいねされたactivityが選択されること' do
              @activities.first.type_id.must_equal 'thumbup_reply'
            end
          end

          context 'その他のuserを指定して実行したとき' do
            before { @activities = Activity.related_user(create(:user)) }

            it 'レコードが選択されないこと' do
              @activities.blank?.must_equal true
            end
          end
        end
      end
    end
  end
end
