json.array! @attempts.each_with_index.to_a do |(attempt, index)|
  json.positon index + 1
  json.name attempt.player.nickname
  json.elapsed_time attempt.elapsed_time(pretty: true)
  json.date (attempt.finished_at.present? ? attempt.finished_at : attempt.started_at).to_date
  json.stops_visited attempt.attempt_stops.visited.size
  json.total_stops attempt.attempt_stops.size
end
