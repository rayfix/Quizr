//
//  StartViewController.swift
//  Quizr
//
//  Created by Ray Fix on 12/8/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  @IBOutlet weak var startButton: CustomButton!
  
  override func viewDidLoad() {
    startButton.backgroundColor = FlatRedDark()
    startButton.padding = CGSize(width: 120, height: 60)
  }

}
