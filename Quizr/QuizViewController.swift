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

  @IBOutlet weak var tableView: UITableView!
  var statusOverlay: ResourceStatusOverlay!
  
  var network =  quizNetwork // ready for dependency injection
  
  var quizRun: QuizRun? {
    didSet {
      updateViews()
    }
  }
  
  var currentQuestion: Question? {
    return quizRun?.current
  }
  
  var progressString: String {
    guard let quizRun = quizRun else { return "" }
    return "\(quizRun.index+1) / \(quizRun.quiz.questions.count)"
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    statusOverlay.positionToCover(view)
  }
  
  var feedback: String = " "

  func updateViews() {
    title = quizRun?.quiz.title ?? "Quizr"
    tableView.reloadData()
  }
  
  @IBAction func answer(sender: UIButton) {

    if let response = sender.titleLabel?.text
    {
      if quizRun!.advance(response) {
        feedback = progressString
      }
      else {
        feedback = "Sorry"
      }
      updateViews()
      if quizRun!.isDone {
        navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView?.separatorColor = .clearColor()
    tableView?.dataSource = self
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    
    statusOverlay = ResourceStatusOverlay()
    statusOverlay.embedIn(self)
    statusOverlay.loadingIndicator?.color = FlatRed()
    let retryButtonAppearance = UIButton.appearanceWhenContainedInInstancesOfClasses([ResourceStatusOverlay.self])
    retryButtonAppearance.backgroundColor = .whiteColor()
    retryButtonAppearance.setTitleColor(FlatBlue(), forState: .Normal)
    
    network.questions.addObserver(statusOverlay)
    
    network.questions.addObserver(owner: self) { [weak self] resource, event in

      guard let strongSelf = self else { return }
      let json = JSON(resource.jsonDict)
      if let quiz = try? Quiz(json: json) {
        strongSelf.quizRun = QuizRun(quiz: quiz)
        strongSelf.feedback = strongSelf.progressString
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    network.questions.loadIfNeeded()
  }

  enum TableSections : Int {
    case Question, Feedback, Choices, Size
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch indexPath.section {
      case TableSections.Question.rawValue:
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionTableViewCell
        cell.questionLabel.text = currentQuestion?.question
        return cell
      case TableSections.Feedback.rawValue:
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedbackCell", forIndexPath: indexPath) as! FeedbackTableViewCell
        cell.feedbackLabel.text = feedback
        return cell
      case TableSections.Choices.rawValue:
        let cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! ChoiceTableViewCell
          if let button = cell.choiceButton {
            button.setTitle(currentQuestion?.choices[indexPath.row], forState: .Normal)
          }
        return cell
      default:
        fatalError("invalid section")
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case TableSections.Question.rawValue:
        return 1
      case TableSections.Feedback.rawValue:
        return 1
      case TableSections.Choices.rawValue:
        return currentQuestion?.choices.count ?? 0
      default:
        fatalError("invalid section")
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return quizRun != nil ? TableSections.Size.rawValue : 0
  }
}

