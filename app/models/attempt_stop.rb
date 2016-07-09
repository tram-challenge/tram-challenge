class AttemptStop < ApplicationRecord
  belongs_to :attempt
  belongs_to :stop

  scope :visited, -> { where.not(visited_at: nil) }

  after_commit :check_attempt_completion, if: :persisted?

  def elapsed_time
    elapsed = self.visited_at - attempt.started_at
    mm, ss = elapsed.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    if dd > 0
      "%02d:%02d:%02d:%02d" % [dd, hh, mm, ss]
    else
      "%02d:%02d:%02d" % [hh, mm, ss]
    end
  end

  private def check_attempt_completion
    if attempt.attempt_stops.where(visited_at: nil).none?
      last_stop = attempt.attempt_stops.order("visited_at ASC").last
      attempt.finished_at ||= last_stop.visited_at
      attempt.save!
    else
      if attempt.finished_at
        attempt.finished_at = nil
        attempt.save!
      end
    end
  end
end
