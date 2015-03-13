# == Schema Information
#
# Table name: information
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  body        :text
#  image       :string
#  user_id     :integer
#  started_on  :date
#  ended_on    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_information_on_started_on_and_ended_on  (started_on,ended_on)
#

FactoryGirl.define do
  factory :information do
    title "MyString"
description "MyString"
body "MyText"
image "MyString"
user_id 1
started_on "2015-03-13"
ended_on "2015-03-13"
  end

end
