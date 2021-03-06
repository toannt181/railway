require 'json'

class MoviesController < ApplicationController
  before_action :logged_in_user

  def index
    @movies = MovieService.listAll
  end

  def show
    @movie = MovieService.find(params[:id])
    @comments = CommentService.findByMovieId(params[:id])
    @comment = CommentService.new
  end

  def new
    @movie = MovieService.new
    get_movie_actors
  end

  def edit
    @movie = MovieService.find(params[:id])
    get_movie_actors
  end

  def create
    @movie = MovieService.create(movie_params)

    if @movie.valid?
      redirect_to @movie
    else
      render :new
    end
  end

  def update
    @movie = MovieService.updateMovieId(params[:id], movie_params)

    if @movie.valid?
      redirect_to @movie
    else
      render :edit
    end
  end

  def destroy
    MovieService.destroy(params[:id])
    redirect_to movies_path
  end

  def destroy_thumbnail
    @movie = MovieService.find(params[:movie_id])
    thumbnail_id = params[:thumbnail_id]
    thumbnail = @movie.thumbnails.find(thumbnail_id)
    thumbnail.purge
    render json: { success: true }
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :description, :release_date, actors: [], thumbnails: [])
    end

    def get_movie_actors
      @actors = ActorService.listAll
      @actors_json = @actors
        .map { |actor| { id: actor.id, picture: actor.image.attached? ? url_for(actor.image) : '/images/img-avatar-default.png' } }
        .to_json
    end
end
