module AttemptsHelper
  def local_time_date(time)
    time.in_time_zone("Helsinki").to_formatted_s(:long)
  end
end
