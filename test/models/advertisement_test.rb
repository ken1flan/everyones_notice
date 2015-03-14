# == Schema Information
#
# Table name: advertisements
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  summary    :string           not null
#  body       :text             not null
#  image      :string
#  started_on :date             not null
#  ended_on   :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_advertisements_on_started_on_and_ended_on  (started_on,ended_on)
#  index_advertisements_on_updated_at               (updated_at)
#

require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
