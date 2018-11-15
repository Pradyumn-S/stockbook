class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :user_stock
  has_many :stocks, through: :user_stock
  
  has_many :friendship
  has_many :friends, through: :friendships
  
  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stock.where(stock_id: stock.id).exists?
  end
  
  def under_stock_limit?
    (user_stock.count < 10)
  end
  
  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end
  
  def full_name
    return "#{first_name} #{last_name}".strip if first_name || last_name
    "Anonymous"
  end
end
