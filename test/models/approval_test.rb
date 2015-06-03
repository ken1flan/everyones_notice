# == Schema Information
#
# Table name: approvals
#
#  id              :integer          not null, primary key
#  approvable_id   :integer
#  approvable_type :string
#  user_id         :integer
#  deleted         :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_approvals_on_approvable_type_and_approvable_id  (approvable_type,approvable_id)
#  index_approvals_on_user_id                            (user_id)
#

require 'test_helper'

class ApprovalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
