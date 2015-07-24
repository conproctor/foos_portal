class Game < ActiveRecord::Base
  has_many :results

  scope :in_progress, -> { where('finished_at IS NULL AND abandoned = false AND started_at IS NOT NULL') }
  scope :in_setup, -> { where(started_at: nil, abandoned: false) }

  validates_inclusion_of :abandoned, in: [true, false]
  validates_presence_of :started_at, if: -> { finished_at.present? }

  def in_progress?
    started_at.present? && !abandoned && finished_at.nil?
  end

  def in_setup?
    started_at.nil? && !abandoned
  end

  def players_needed
    4 - results.map(&:user_id).length
  end
end