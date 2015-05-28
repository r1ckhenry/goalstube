require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry'

get '/' do 
  redirect to '/videos'
end 

get '/videos' do
  sql = "select * from videos"
  @my_videos = sql_run(sql)
  erb :index
end

get '/videos/new' do 

  erb :new
end

post '/videos' do
  sql = "insert into videos (title, details, url) values ('#{params[:title]}', '#{params[:details]}', '#{params[:url]}')"
  sql_run(sql)

  redirect to ('/videos')
end

get '/videos/:id' do 
  sql = "select * from videos where id = #{params[:id]}"
  @show_vid = sql_run(sql).first

  erb :show
end

get '/videos/:id/edit' do 
  sql = "select * from videos where id = #{params[:id]}"
  @video = sql_run(sql).first

  erb :edit
end

post '/videos/:id' do 
  sql = "update videos set title = '#{params[:title]}', details = '#{params[:details]}', url = '#{params[:url]}' where id = #{params[:id]}"
  sql_run(sql)
  redirect to ("/videos/#{params[:id]}")
end

delete '/videos/:id/delete' do 
  sql = "delete from videos where id = #{params[:id]}"
  sql_run(sql)
  redirect to ('/videos')
end

private

def sql_run(sql)
  conn = PG.connect(dbname: 'youtube', host: 'localhost')
  begin
    result = conn.exec(sql)
  ensure
    conn.close
  end
  result
end