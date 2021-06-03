class UsersController < ApplicationController
  before_action :authenticate_user!
    def index
        
        if params[:search] == nil
            @users = User.all.page(params[:page]).per(4)
          elsif params[:search] == ''
            @users = User.all.page(params[:page]).per(4)
          else
            #部分検索
            search = params[:search]
            @users = User.where("name LIKE ? OR labo LIKE ? OR course LIKE ? ","%#{search}%", "%#{search}%", "%#{search}%").page(params[:page]).per(4)
          end
    end

    def show
        @user = User.find(params[:id]) 
        @currentUserEntry=Entry.where(user_id: current_user.id)
        @userEntry=Entry.where(user_id: @user.id)
        @questions =@user.questions.page(params[:page]).per(4)
        if @user.id == current_user.id
        else
          @currentUserEntry.each do |cu|
            @userEntry.each do |u|
              if cu.room_id == u.room_id then
                @isRoom = true
                @roomId = cu.room_id
              end
            end
          end
          if @isRoom
          else
            @room = Room.new
            @entry = Entry.new
          end
        end
     end 
    
end
