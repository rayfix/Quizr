//
//  Quiz.swift
//  Quizr
//
//  Created by Ray Fix on 12/7/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

// This is the model for our quizing app.

import Foundation

struct Question {
  let question: String
  let choices: [String]
  let answerIndex: Int
  
  var answer: String {
    return choices[answerIndex]
  }
}

struct Quiz {
  let title: String
  let author: String
  let questions: [Question]
}

struct QuizRun {
  let quiz: Quiz
  private(set) var wrongAnswers = 0
  private(set) var index = 0
  
  init(quiz: Quiz) {
    self.quiz = quiz
  }
  
  var current: Question? {
    guard !isDone else { return nil }
    return quiz.questions[index]
  }
  
  var isDone: Bool { return index >= quiz.questions.count }
  
  mutating func next() {
    index += 1
  }
  
  mutating func restart() {
    index = 0
    wrongAnswers = 0
  }
  
  mutating func advance(answer: String) -> Bool {
    if answer == current!.answer {
      next()
      return true
    }
    else {
      wrongAnswers += 1
      return false
    }
  }
}


import SwiftyJSON

typealias JSONDictionary = [String: AnyObject]

protocol JSONConvertible {
  init(json: JSON) throws
}

extension Question : JSONConvertible {
  init(json: JSON) throws {
    question = json["question"].stringValue
    answerIndex = json["answer"].intValue
    
    var choices: [String] = []
    for choice in json["choices"].arrayValue {
      choices.append(choice.stringValue)
    }
    self.choices = choices
  }
}

extension Quiz : JSONConvertible {
  
  enum Error : ErrorType {
    case NoTitle
  }
  
  init(json: JSON) throws {
    guard let title = json["title"].string else { throw Error.NoTitle }
    self.title = title
    self.author = json["author"].stringValue
    var questions: [Question] = []
    for question in json["questions"].arrayValue {
      questions.append(try Question(json: question))
    }
    self.questions = questions
  }
}
