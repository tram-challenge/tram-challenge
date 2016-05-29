if Stop.none?
  abort "Run './bin/rails stops:fetch' first"
end

players = [
  {
    nickname: "Robert'); DROP TABLE students;--",
    icloud_user_id: "aac1a3fd-a17a-40aa-a61d-902b955c28a5"
  },
  {
    nickname: "Never Talk To Strangers",
    icloud_user_id: "210c8fdd-6a43-437d-a02a-45e6ec876f1f"
  },
  {
    nickname: "Ford Prefect",
    icloud_user_id: "aac1a3fd-a17a-40aa-a61d-902b955c28a5"
  }
]

ActiveRecord::Base.transaction do

  players.each do |attributes|
    player = Player.find_or_initialize_by(icloud_user_id: attributes[:icloud_user_id])
    player.assign_attributes(attributes)
    player.save!

    attempt = player.attempts.create(started_at: (Random.rand(3..17).days.ago))
    running_time = attempt.started_at
    attempt.attempt_stops.each_with_index do |stop, index|
      stop.visited_at = running_time
      stop.save!

      pp running_time
      running_time = running_time + (Random.rand(1..10).minutes) + Random.rand(17..59).seconds
    end
  end

end
