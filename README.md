# MDBSocials

This app allows users to create an account and post "Socials" which are events that are about to happen. 
Other users are then able to RSVP to come to those events.

# Features

The majority of the functionality was done using Firebase. Firebase Authentication/Database/Storage were all used for various parts.

# In Action

The app starts with this log in screen :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 30](https://user-images.githubusercontent.com/17814417/36574846-706120f6-17fc-11e8-82f1-ce28b6696628.png)

You can choose to sign up instead which pops up a sign up form :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 32](https://user-images.githubusercontent.com/17814417/36574871-927dcf54-17fc-11e8-8ed7-c97aefc79197.png)

Once you are logged in, you are brought to the feed. This is where users posts will show up. This is updated real time and doesn't 
require the user to refresh to see new posts as they come in.

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 28](https://user-images.githubusercontent.com/17814417/36574905-af8410d6-17fc-11e8-8d7f-ab294c424392.png)

Clicking on a cell will transition into a more detailed view of it. For example :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 18 42](https://user-images.githubusercontent.com/17814417/36574941-d7e59c66-17fc-11e8-9498-5ab98f8e6003.png)

In order to create a new post, from the feed you click the plus in the top right. It leads to this page :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 42](https://user-images.githubusercontent.com/17814417/36574954-f1337dc8-17fc-11e8-9b8f-fbe0db4f6256.png)

It is very straightforward and allows you to input all the information.

# Libraries used

Apart from firebase, I used the HERO library.

* https://github.com/lkzhao/Hero

It was used for animation, specifically the one from the cells on the feed to the more detailed view.

# Created by

This was created by me.
