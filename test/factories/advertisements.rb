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

FactoryGirl.define do
  factory :advertisement do
    title { 'title' + ('a'..'z').to_a.sample(26).join }
    summary { 'summary' + ('a'..'z').to_a.sample(26).join }
    body { 'body' + ('a'..'z').to_a.sample(26).join }
    started_on { (rand(10) + 1).days.ago.to_date.to_s }
    ended_on { (rand(10) + 10).days.since.to_date.to_s }
    user
  end
end
