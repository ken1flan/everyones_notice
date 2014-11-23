# coding: utf-8
require 'test_helper'

class ReplyDecoratorTest < ActiveSupport::TestCase
  def setup
    @reply = Reply.new.extend ReplyDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
