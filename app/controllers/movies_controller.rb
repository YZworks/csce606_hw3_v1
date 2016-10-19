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
    @movies = Movie.all
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    @select = params[:ratings]

    if (@sort!=nil && @select!=nil)
      flash.keep
      @movies =  Movie.where(:rating => @select.keys).order(@sort + ' ASC')
    end
    
    if @select!=nil
	      @movies = Movie.where(:rating => @select.keys)
    else
       @select = {}
    end

    if @sort!=nil
      if @select!={}
        @movies = Movie.where(:rating => @select.keys).order(@sort + ' ASC')
      else
	      @movies = Movie.order(@sort + ' ASC')
	    end
    end
    @movies
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
