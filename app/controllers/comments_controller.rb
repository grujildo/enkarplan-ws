class CommentsController < ApplicationController

  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.json { render json: @comments }
    end
  end

  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.json { render json: @comment }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    params[:comment][:user_id] = session[:current_user_id]
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

end
