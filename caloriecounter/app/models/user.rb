class User < ActiveRecord::Base
    has_secure_password
    has_many :entries
    validates :email, uniqueness: true
  
  def calorie_amount
    entries.collect {|entry| entry.calories}.sum
  end

  def entries_sort_by_date
    entries.sort_by {|entry| entry[:date]}.reverse
  end
end