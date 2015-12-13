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


import SwiftyJSON

typealias JSONDictionary = [String: AnyObject]

protocol JSONConvertible {
  init?(json: JSON)
}

extension Question : JSONConvertible {
  init?(json: JSON) {
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
  init?(json: JSON) {
    self.title = json["title"].stringValue
    self.author = json["author"].stringValue
    var questions: [Question] = []
    for question in json["questions"].arrayValue {
      if let q = Question(json: question) {
        questions.append(q)
      }
    }
    self.questions = questions
  }
}
