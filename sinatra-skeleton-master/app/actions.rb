require 'pry'
helpers do

  def check_user
    @user = User.find_by(id: session[:user_id])
    if @user
      session.delete(:login_error)
    else
      session[:login_error] = "You must be logged in."
      redirect '/login'
    end
  end

end

# Homepage (Root path)
get '/' do
  user_id = session[:user_id]

  if !user_id
    redirect '/login'
  else
    @songs = User.find(user_id).songs
    erb :index
  end
end

get '/signup' do
  @user = User.new
  erb :signup
end

post '/signup' do
  @user = User.new
  @user.name = params[:name]
  @user.email = params[:email]
  @user.password = params[:password]
  @user.password_confirmation = params[:password_confirmation]

  if @user.save
    session[:user_id] = @user.id
    redirect '/songs'
  else
    erb :signup
  end
end

get '/login' do
  erb :login
end

# could also be implemented as a delete
get '/logout' do
  session[:user_id] = nil
  redirect '/login'
end

# post '/login' do
#   email = params[:email]
#   password = params[:password]

#   user = User.find_by(email: email)
#   if user.password == password
#     session[:user_id] = user.id
#     redirect '/songs'
#   end
# end

post '/validate' do
  email = params[:email]
  password = params[:password]
  user = User.find_by(email: email, password: password)
  if user
    session[:user_id] = user.id
    redirect '/songs'
  else
    session.delete(:user_id)
    session[:login_error] = "You must be logged in."
    redirect '/login'
  end
end

# get '/' do
#   erb :index
# end

get '/songs' do
  @songs = Song.where(user_id: session[:user_id])
  erb :'songs/index'
end

get '/songs/new' do
  @song = Song.new
  erb :'songs/new'
end

post '/songs' do
  @song = Song.new(
    title: params[:title],
    author: params[:author],
    url: params[:url],
    user_id: session[:user_id]
  )
  if @song.save
     redirect '/songs'
   else
     erb :'songs/new'
   end
end

get '/songs/:id' do
  @song = Song.find params[:id]
  erb :'songs/show'
end

get '/all_songs' do
  @songs = Song.all.sort_by {|s| s.likes.count}.reverse
  # Song.find_by_sql "SELECT s.title FROM songs AS s INNER JOIN likes AS l ON s.id = l.song_id ORDER BY likes"
  erb :'all_songs'
end

post '/songs/:song_id/upvotes' do
  if Like.where(song_id: params[:song_id], user_id: session[:user_id]).empty?
    Like.create(song_id: params[:song_id], user_id: session[:user_id])
    @song = Song.find(params[:song_id])
    @song.upvotes = Like.where(song_id: params[:song_id]).count
    @song.save
    redirect '/all_songs'
  else
    redirect '/all_songs'
  end
end