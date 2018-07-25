class User < ApplicationRecord
  before_save {self.email.downcase! }

  validates :name, presence: true, length: { maximum:50 }
  validates :email, presence: true, length: { maximum:255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :images, dependent: :destroy, class_name: Image
  has_many :authorizations, dependent: :destroy, class_name: Authorization
  
  def User.create_from_auth!(auth)
    name = auth["info"]["name"]
    email = auth["info"]["email"]
    password = auth["uid"].to_s + ENV["SNS_PASS"]

    self.create(name: "#{name}", email: "#{email}" , password: "#{password}")
    
  end
  #issue : FBとTwitterで同じアドレス使ってる人は2重登録できない→emailに文字列付与すればできるが現状このままで

end
