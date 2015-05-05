class UtilsController < ApplicationController
  def markdown
    render text: markdown_to_html(params[:src])
  end
end
