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

post '/login' do
  email = params[:email]
  password = params[:password]

  user = User.find_by(email: email)
  if user.password == password
    session[:user_id] = user.id
    redirect '/songs'
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