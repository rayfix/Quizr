# Quizr
Sample app using Siesta for Xcode study group.

This shows the basics of making client-server app using some basic features from the REST framework Siesta.

## Starting the Server
We used the lightweight, ruby web framework Sinatra to server as backend service.
To run the test server you need the sinatra and json gems installed.  Then run:

```
ruby server.rb
```

## Changes since the meetup:
- Added more than one question quiz!
- Quiz "grading"
- Broke out the model object, and JSON handling into a separate file 
- Dependency inject the singleton Network service into our view controller

My plan is to cover these changes at the next meetup and any additional feedback that I get.

## Future Directions

- More than one quiz
- Score the quiz
- Leaderboard
- Allow users to make their own quiz
