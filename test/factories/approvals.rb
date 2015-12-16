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

FactoryGirl.define do
  factory :approval do
    approvable nil
user_id 1
  end

end
