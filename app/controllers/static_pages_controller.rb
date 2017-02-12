class StaticPagesController < ApplicationController
  def home
  end

  def buffet
    @all_posts = Post.all
    Rails.cache.write("posts", @all_posts)
    session[:currentIndex] = @all_posts.count
    @current_post = @all_posts.find_by(id: session[:currentIndex]);
  end

  def kitchen
  end

  def handle_next

    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]-1)


    respond_to do |format|
      format.js
    end
  end

  def handle_prev

    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]+1)

    respond_to do |format|
      format.js
    end
  end

end
