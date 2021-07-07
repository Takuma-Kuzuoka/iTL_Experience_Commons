class QuestionsController < ApplicationController
    before_action :authenticate_user!
    def index

        if params[:search] == nil
          @questions = Question.all.order(created_at: :desc).page(params[:page]).per(4)
        elsif params[:search] == ''
          @questions = Question.all.order(created_at: :desc).page(params[:page]).per(4)
        else
          #部分検索
          @questions = Question.where("content LIKE ? ",'%' + params[:search] + '%').order(created_at: :desc).page(params[:page]).per(4)
        end
    end
   
    def show
        @question = Question.find(params[:id])
        @comments = @question.comments
        @comment = Comment.new
    end 
     
    def new
        @question = Question.new
    end

    def create
        question = Question.new(question_params)
        question.user_id = current_user.id
        if question.save
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
    end
    
    
    def edit
        @question = Question.find(params[:id])
    end
    
    def update
        question = Question.find(params[:id])
        if question.update(question_params)
          redirect_to :action => "show", :id => question.id
        else
          redirect_to :action => "new"
        end
    end

    def destroy
      question = Question.find(params[:id])
      question.destroy
      redirect_to action: :index
    end



    private
    def question_params
      params.require(:question).permit(:title, :content)
    end

    

end