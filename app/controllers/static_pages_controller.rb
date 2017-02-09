class StaticPagesController < ApplicationController
  def home
  end

  def buffet
    @all_posts = Post.all
  end

  def kitchen
  end
end
