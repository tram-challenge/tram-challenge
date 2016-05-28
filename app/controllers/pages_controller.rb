class PagesController < ApplicationController
  def home
    set_tab :home
  end

  def map
    set_tab :map
  end
end
