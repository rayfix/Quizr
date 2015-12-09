require 'sinatra'
require 'json'

questions = [

  {question: "How do you say cat in Japanese?", choices: 
    ["neko", "inu", "tori", "nezumi"], answer: 0 },

  {question: "All objects in Objective-C derive from what?", choices: 
    ["NSClass", "Base", "Foundation", "NSObject"], answer: 3 },

  {question: "How do you say mouse in Japanese?", choices: 
    ["neko", "inu", "tori", "nezumi"], answer: 3 },

  {question: "What id the memory management system on iOS called?", choices: 
    ["ARM", "AAR", "ARC", "ACC"], answer: 2 },

  {question: "What is the spin of an electron?", choices: 
    ["0", "1/2", "1", "2"], answer: 1 },

  {question: "How many cups in a gallon?", choices: 
    ["10", "12", "8", "16"], answer: 3 },

  {question: "How do you force unwrap a swift optional?", choices: 
    ["force", "!", "?", "++"], answer: 1 }
]

quiz = {
  title: "Random",
  author: "Mr. Kittens",
  questions: questions
}

# Question Endpoint

get '/questions.json' do 
  content_type :json

  # Simulate some network traffic
  sleep 2

  return quiz.to_json
end