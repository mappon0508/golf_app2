class PracticeMenu < ApplicationRecord
    has_many :practice_schedules

    
    validates :level, inclusion: { in: %w(hundred_over within_hundred within_ninety within_eighty_fiv within_eighty within_seventy_five under_par) }
    enum level: { hundred_over: 0, within_hundred: 1, within_ninety: 2, within_eighty_fiv: 3, within_eighty: 4, within_seventy_five: 5, under_par: 6}

    validates :category, inclusion: { in: %w( tee_shot shot_within_two_hundredone_from_hundred_fifty shot_within_hundred_fifty_from_hundred approach_shot approach bunker long_putt short_putt) }
    enum category: { tee_shot: 0, shot_within_two_hundredone_from_hundred_fifty: 1, shot_within_hundred_fifty_from_hundred: 2, approach_shot: 3, approach: 4, bunker: 5, long_putt: 6, short_putt: 7,}

    validates :practice_type, inclusion: { in: %w( short_game shot_game) }
    enum practice_type: { short_game: 0, shot_game: 1, }

end
