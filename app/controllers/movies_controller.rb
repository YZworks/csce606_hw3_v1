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

    if (@sort!=nil && @select!={})
      flash.keep
      @movies =  Movie.where(:rating => @select.keys).order(@sort + ' ASC')
    end
 
    if @select!=nil
	    session[:savedRatings] = @select
	    if (session[:savedSortVal]!=nil)
	    	@movies = Movie.where(:rating => @select.keys).order(session[:savedSortVal] + ' ASC')
	    else
	      @movies = Movie.where(:rating => @select.keys)
	    end
    else
      @select = {}
    end

    if @sort!=nil
      session[:savedSortVal] = @sort
      if @select!={}
        @movies = Movie.where(:rating => @select.keys).order(@sort + ' ASC')
      else
	      @movies = Movie.order(@sort + ' ASC')
	    end
    end

    if (@sort==nil && @select=={} && (session[:savedSortVal]!=nil or session[:savedRatings]!=nil))
      flash.keep
	    redirect_to movies_path(:sort => session[:savedSortVal], :ratings => session[:savedRatings])
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
