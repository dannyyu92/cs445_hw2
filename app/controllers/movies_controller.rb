class MoviesController < ApplicationController
  helper_method :hilite?, :checked?
  before_filter :persist_sort_session

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.order(session[:sort]).all
    @all_ratings = Movie.uniq.pluck(:rating).sort
    @saved_ratings = params[:ratings]

    saved_ratings_nil? 

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def hilite?(header_name)
    params[:sort] == (header_name.to_s)? 'hilite':nil
  end

  def checked?(rating)
    (@saved_ratings.has_key?(rating) || @saved_ratings == {})? true:false
  end

  def saved_ratings_nil?
    if @saved_ratings == nil
      @saved_ratings = {}
    else 
      @movies = Movie.where(:rating => @saved_ratings.keys).order(session[:sort])
    end
  end

  def persist_sort_session
    if !params[:sort].present?
      params[:sort] = session[:sort]
    end
    session[:sort] = params[:sort]
  end

end
