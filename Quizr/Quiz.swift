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

// JSON Handling: maybe we could swify json to help us out here
//
// FIXME: should use throwing inits handling to give richer failure
// information.  Next version :)

typealias JSONDictionary = [String: AnyObject]

protocol JSONConvertible {
  init?(JSON: JSONDictionary)
}

extension Question : JSONConvertible {
  init?(JSON: JSONDictionary) {
    guard let question = JSON["question"] as? String else { return nil }
    self.question = question
    guard let answerIndex = JSON["answer"] as? Int else { return nil }
    self.answerIndex = answerIndex
    guard let choices = JSON["choices"] as? [String] else { return nil }
    self.choices = choices
    guard choices.indices.contains(answerIndex) else { return nil }
  }
}

extension Quiz : JSONConvertible {
  init?(JSON: JSONDictionary) {
    guard let title = JSON["title"] as? String else { return nil }
    self.title = title
    guard let author = JSON["author"] as? String else { return nil }
    self.author = author
    
    var questions: [Question] = []
    guard let JSONQuestions = JSON["questions"] as? [JSONDictionary] else { return nil }
    for JSONQuestion in JSONQuestions {
      if let q = Question(JSON: JSONQuestion) {
        questions.append(q)
      }
    }
    self.questions = questions
  }
}


