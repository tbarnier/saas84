class MoviesController < ApplicationController
helper_method :sort_column, :sort_direction
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	if params[:sort] != nil
		session[:sort] = params[:sort]
	end
	@sort=session[:sort]
	logger.debug @sort
	
	if params[:ratings] != nil
		session[:ratings] = params[:ratings]
	end
	@rating=session[:ratings]

	if(@rating == nil)
		if(@sort == nil)
			@sort='id'
		end
		@movies = Movie.order(@sort)
	else
		@movies = Movie.where(rating: @rating.keys).order(@sort)
	end
	@all_ratings=['G','PG','PG-13','R']
	@r = @rating
	if(@r==nil)
		@r={'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','R'=>'R'}
	end
	puts @r
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

end
