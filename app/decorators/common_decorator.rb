# coding: utf-8
module CommonDecorator
  def created_at_string
    created_at.strftime '%Y/%m/%d %H:%M:%S'
  end

  def updated_at_string
    updated_at.strftime '%Y/%m/%d %H:%M:%S'
  end
end
