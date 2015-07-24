# fyberchallenge
Sinatra app that uses Fyber API to return a set of results depending on params set by the user.

It has one page that renders the initial view with three fields, only the first being required.

On successful API call, it returns the results and renders them via a JS file. Errors are also treated with JS and messages are rendered in the browser in case of errors.

I decided to go with Sinatra, not because it is easy, but because it suited the needs of the challenge better than any other framework. Also, I haven't started a Sinatra app from the ground up before, so it was a challenge for me as well to finish this app.
Because I only have two pages I really didn't want to go with Rails. I did however use jQuery UJS that has been developed for Rails just so that I can make more eficient remote calls and parse the results I got.

The architecture is a bit weird, I admit I could have just made a simple page and rely on jQuery for everthing or I could have just made different pages for the results, but I wanted a nice user experience and also wanted to showcase my style of coding.

I used bootstrap for the layout and decided to render everything within erb files, including the response from the server after the api call.

I implemented rspec tests, however they are only a few, testing the calls that can be made to the app. I also added coverage so i can see how much of my code is covered by the tests.

Code has been optimised for quality using Rubocop. There are a few lines too long, but they are mostly because of comment.


