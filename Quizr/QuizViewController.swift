//
//  ViewController.swift
//  Quizr
//
//  Created by Ray Fix on 12/5/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

import UIKit
import Siesta
import SwiftyJSON

class QuizViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var feedbackLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var network =  quizNetwork // ready for dependency injection
  
  var questionIndex = 0 {
    didSet {
      updateViews()
    }
  }
  var currentQuestion: Question? {
    return quiz?.questions[questionIndex]
  }
  
  var quiz: Quiz? {
    didSet {
      updateViews()
    }
  }
  
  func updateViews() {
    title = quiz?.title ?? "Quizr"
    questionLabel.text = currentQuestion?.question
    tableView.reloadData()
  }
  
  @IBAction func answer(sender: UIButton) {
    if let attempt = sender.titleLabel?.text,
           answer =  currentQuestion?.answer
    {
      if  attempt == answer {
        feedbackLabel.text = ""
        nextQuestion()
      }
      else {
        feedbackLabel.text = "Sorry"
      }
    }
  }
  
  func nextQuestion() {
    guard let quiz = quiz else { return }
    
    if questionIndex < quiz.questions.count-1 {
      questionIndex += 1
    }
    else {
      navigationController?.popToRootViewControllerAnimated(true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView?.separatorColor = .clearColor()
    tableView?.dataSource = self
    network.questions.addObserver(owner: self) { [weak self] resource, event in
      guard let strongSelf = self else { return }
      strongSelf.activityIndicator.hidden = !resource.loading
      if case .NewData = event {
        let json = JSON(resource.jsonDict)
        strongSelf.quiz = Quiz(json: json)
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    network.questions.loadIfNeeded()
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ChoiceTableViewCell
    
    if let button = cell.choiceButton {
      button.setTitle(currentQuestion?.choices[indexPath.row], forState: .Normal)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentQuestion?.choices.count ?? 0
  }
}

