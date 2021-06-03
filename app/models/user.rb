class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        

        validates_uniqueness_of :memberId
        validates_presence_of :memberId
        validates :name, presence: true #追記
        validates :profile, length: { maximum: 400 } #追記
          
        #memberIdを利用してログインするようにオーバーライド
        def self.find_first_by_auth_conditions(warden_conditions)
            conditions = warden_conditions.dup
            if login = conditions.delete(:login)
        #認証の条件式を変更する
               where(conditions).where(["memberId = :value", { :value => memberId }]).first
            else
               where(conditions).first
            end
        end
        
        def email_required?
          false
        end
      
        def email_changed?
          false
        end

        mount_uploader :image, ImageUploader

        has_many :questions, dependent: :destroy
        has_many :comments, dependent: :destroy
        has_many :messages, dependent: :destroy
        has_many :entries, dependent: :destroy
        has_many :rooms, through: :entries, source: :room
        has_many :likes, dependent: :destroy
        has_many :liked_questions, through: :likes, source: :question
        
        #relationship
        #foregin_key = 入口 
        #source = 出口

        has_many :relationships 
        has_many :followings, through: :relationships, source: :follow #「relationshipsテーブルのfollow_idを参考にして、followingsモデルにアクセスしてね」
        has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id' 
        has_many :followers, through: :reverse_of_relationships, source: :user

        def follow(other_user) #followingの時点でもうクリエイトしてるのに（クリエイトはセーブを含むから）次の行のセーブはいるのか？
          unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
          end
        end
      
        def unfollow(other_user)
          relationship = self.relationships.find_by(follow_id: other_user.id)
          relationship.destroy if relationship
        end
      
        def following?(other_user)
          self.followings.include?(other_user)
        end


        def already_liked?(question)
          self.likes.exists?(question_id: question.id)
        end

      
      
end
