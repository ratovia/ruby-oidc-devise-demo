class TopController < ApplicationController
  before_action :authenticate_user!, only: :example

  def index
  end

  def example
  end
end
