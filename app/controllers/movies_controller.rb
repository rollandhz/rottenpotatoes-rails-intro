class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
     @all_ratings = Movie.all_ratings
     
    rating = params[:ratings]
    
    
    if(rating)
      @movies = Movie.where(rating: rating.keys)
      session[:rating] =rating
    elsif(session[:rating])
      rating = session[:rating]
      @movies = Movie.where(rating: session[:rating].keys)
    else
      @movies =Movie.all
    end
    
    
    
    sort = params[:sort]
    
    if(sort=='title')
      @movies =Movie.order('title ASC')
      @tHighlighted = 'hilite'
      session[:sort] =sort
    elsif(sort == 'release_date')
      @movies = Movie.order('release_date ASC')
      @rHighlighted = 'hilite'
      session[:sort] =sort
    elsif(rating)
      @movies = Movie.where(rating: rating.keys)
    elsif(session[:sort]=='title')
      sort = session[:sort]
      @movies = Movie.all.order(session[:sort])
      @tHighlighted = 'hilite'
    elsif(session[:sort]=='title')
      sort = session[:sort]
      @movies = Movie.all.order(session[:sort])
      @rHighlighted = 'hilite'
    else
        @movies = Movie.all
    end
    
    session[:ratings] =rating
    session[:sort] = sort
   
    
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
