class MoviesController < ApplicationController
  helper_method :hilite

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating).sort

    update_sessions

    @saved_ratings = params[:ratings] || session[:ratings] || {}
    check_empty_ratings

    @sort = params[:sort] || session[:sort]

    check_for_redirects

    @movies = Movie.where(:rating => @saved_ratings.keys).order(@sort)

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

  def hilite(header_name)
    @sort == (header_name.to_s)? 'hilite':nil
  end

  def update_sessions
    if params[:sort].present?
      session[:sort] = params[:sort]
    end

    if params[:ratings].present?
      session[:ratings] = params[:ratings]
    end
  end

  def check_empty_ratings
    if @saved_ratings == {}
      @saved_ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
    end
  end

  def check_for_redirects
    if !params[:sort].present? && !params[:ratings].present? && session[:sort].present? && session[:ratings].present?
      params[:sort] = session[:sort]
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to :sort => session[:sort], :ratings => session[:ratings]
    end

    =begin
    if !params[:sort].present? && session[:sort].present? && (params[:ratings].present? || session[:ratings].present?)
      params[:sort] = session[:sort]
      flash.keep
      redirect_to :sort => session[:sort], :ratings => @saved_ratings
    end

    if !params[:ratings].present? && session[:ratings].present? && (params[:sort].present? || session[:sort].present?)
      flash.keep
      redirect_to :sort => @sort, :ratings => session[:ratings]
    end

  end

end