class MoviesController < ApplicationController
  helper_method :hilite?, :checked?

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating).sort
    #session[:ratings] = {}
    saved_ratings_nil?
    persist_sort_session
    persist_ratings_session
    
    @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort])
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
    session[:ratings].has_key?(rating.to_sym)
  end

  def saved_ratings_nil?
      if !session[:ratings].present?
        session[:ratings] = {:G => 1, :PG => 1, "PG-13".to_sym => 1, :R => 1}
      end
  end

  def persist_sort_session
    if !params[:sort].present?
      params[:sort] = session[:sort]
    end
    session[:sort] = params[:sort]
  end

  def persist_ratings_session
    if (params[:ratings] == {} || !params[:ratings].present?)
      params[:ratings] = session[:ratings] if session[:ratings].present?
    else 
      session[:ratings] = params[:ratings]
    end
  end

end