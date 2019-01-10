
require_relative '../../config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    redirect to '/articles'
  end

#shows all articles- index.erb
  get '/articles' do
    @articles = Article.all
    erb :index
  end

#renders new.erb w/ form for new article
  get '/articles/new' do
    @article = Article.new
    erb :new
  end


#creates new instance of Article class with title & content (& id)
#redirects to /articles/#{article.id} to show new article
  post '/articles' do
    @article = Article.create(title: params['title'], content: params['content'])

    #uses this new article's id in route below
    #have to use " ", not ' '
    redirect to "/articles/#{@article.id}"
  end

#searches all articles to find the one with passed in id, sets that article = to @article
#renders show.erb
  get '/articles/:id' do
    @article = Article.find_by_id(params[:id])
    erb :show
  end

#renders edit.erb (edit form)
  get '/articles/:id/edit' do
    @article = Article.find_by_id(params[:id])
    erb :edit
  end

#params[:title] <- in edit.erb, the input name must be 'title'
#saves the new article & content, redirects to show page
  patch '/articles/:id' do
    @article = Article.find_by_id(params[:id])
    #new article title & content = inputted title & content
    @article.title = params[:title]
    @article.content = params[:content]

    @article.save

    redirect to "/articles/#{@article.id}"
  end

#if delete button in show.erb is clicked, deletes the article
  delete '/articles/:id/delete' do
    @article = Article.find_by_id(params[:id])
    @article.delete

    redirect to '/articles'
  end
end
