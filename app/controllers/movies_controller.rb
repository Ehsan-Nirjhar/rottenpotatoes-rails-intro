class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def initialize
    @all_ratings = Movie.all_ratings
    super  ##For retaining the stylesheet
  end

  def index
    @movies = Movie.all
    
    if (params[:ratings])      ## Checking for selection in tick boxes
      session[:ratings] = params[:ratings]  
      @ratings = params[:ratings].keys
    
    elsif (session[:ratings])   ### Remembering the sessions' selection
      params[:ratings] = session[:ratings]
      @ratings = session[:ratings].keys
      
    else
      @ratings = @all_ratings
      
    end
    
    if (params[:sort])
       session[:sort]=params[:sort]
       @sort = params[:sort]
    elsif (session[:sort])   ### Remembering the sessions' sorting
       params[:sort]=session[:sort]
       @sort = session[:sort]
    end

    @movies=Movie.where(rating: @ratings)  ## Show movies with selected rating
    @movies.merge!(Movie.order(@sort))   ## sort according to parameter clicked
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
