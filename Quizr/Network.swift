//
//  Network.swift
//  Quizr
//
//  Created by Ray Fix on 12/9/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

import Siesta

class QuizNetwork : Service {
  
  init() {
    super.init(base: "http://0.0.0.0:4567/")
  }
  
  var questions : Resource {
    return resource("questions.json")
  }
  
}

let quizNetwork = QuizNetwork()
