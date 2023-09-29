class User < ApplicationRecord
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true

    
    validates :password, presence: true, length: { minimum: 6 }

    validates :birthday, presence: true

    validates :gender, inclusion: { in: %w(man woman other) }
    enum gender: { other: 0, man: 1, woman: 2,}

    validates :golf_experience, numericality: { greater_than_or_equal_to: 0 }

    validates :best_score, numericality: { greater_than_or_equal_to: 18 }

    has_secure_password

end
  