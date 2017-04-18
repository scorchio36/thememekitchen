# README

The meme kitchen is a website where you can scroll through memes or make an account and post your own memes. It has all the functionality of a photo-sharing user site. You can like/dislike posts, follow users, recieve notifications, make comments, like/dislike comments, and subscribe to other users. There is also an cookie system in place to keep you logged in, even after you close your browser.


* Ruby on Rails Version 5 on the backend

* I use the shipped testing framework for this project. Not everything is tested and my suite is not extensive. I would like to go back eventually switch this app to RSpec testing.

* Most of the site is dynamically rendered using AJAX. I implemented my ajax through controller listeners, jquery, and erb.

* I am running PostgreSQL as my database

* The site is hosted on hobby servers at Heroku and I am using namecheap.com for my DNS functionality. 

* My images are hosted at Amazon Web Services. I made an AWS administrative account and set up an S3 bibucket to serve all of my image data to my app.
