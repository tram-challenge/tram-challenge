class PagesController < ApplicationController
  def home
    set_tab :home
  end

  def about
    set_tab :about
  end

  def rules
    set_tab :rules
  end

  def map
    set_tab :map
  end
end
