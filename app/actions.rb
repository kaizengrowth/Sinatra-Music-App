# Homepage (Root path)
get '/' do
  erb :index
end

## Secure Login ##

get '/login' do
  erb :login
end

def current_user

  if cookies.has_key? :remember_me
    user = User.find_by_remember_token(cookies[:remember_me])
    return user if user
  end

  if session.has_key?(:user_session)
    user = User.find_by_login_token(session[:user_session])
  else
    nil
  end
end

get '/secure' do
  if current_user
    erb :secure
  else
    redirect '/login'
  end
end

post '/session' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_session] = SecureRandom.hex
    @user.login_token = session[:user_session]

    if params.has_key?(:remember_me) && params[:remember_me] == 'true'

      if @user.remember_token
        response.set_cookie :remember_me, {value: @user.remember_token, max_age: "2592000"}
      else
        response.set_cookie :remember_me, {value: SecureRandom.hex, max_age: "2592000"}
        @user.remember_token = cookies[:remember_me]
      end
    end

    @user.save

    if cookies.has_key? :next_url
      redirect cookies.delete(:next_url)
    else
      redirect '/secure'
    end

  else
    erb :login
  end
end

## END OF SECURE LOGIN ##

## Post song ##

get '/messages' do
  if current_user
    @messages = Message.all
    erb :'messages/index'
  else
    response.set_cookie :next_url, {value: request.path}
    redirect '/login'
  end
end

get '/messages/new' do
  erb :'messages/new'
end

get '/messages/:id' do
  @message = Message.find params[:id]
  erb :'messages/show'
end

post '/messages' do
  @message = Message.new(
    title: params[:title],
    author: params[:author],
    url: params[:url]
  )
  @message.user_id = current_user.id
  if @message.save
    redirect '/messages'
  else
    erb :'messages/new'
  end
end

## END OF POST SONG ##

## Create New User ##

get '/new_login' do
    erb :'new_login'
end

post '/new_login' do
  @user = User.new(
    email: params[:email],
    password: params[:password_digest]
  )
  if @user.save
    redirect '/login'
  else
    erb :'/new_login'
  end
end

put '/logout' do
  session[:user_session] = nil
  redirect '/login'
end

## END OF USER LOGIN / LOGOUT ##

# Upvote #

post '/upvote' do
  Upvote.find_by(user_id: current_user.id, message_id: params[:message_id])
    Upvote.create(
      message_id: params[:message_id],
      user_id: current_user.id
    )
    redirect '/messages'
end

## END OF UPVOTE ##
