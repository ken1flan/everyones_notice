# coding: utf-8
require 'test_helper'

class NoticeDecoratorTest < ActiveSupport::TestCase
  def setup
    @notice = Notice.new.extend NoticeDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
