//
//  ChoiceTableViewCell.swift
//  OneJob
//
//  Created by Ray Fix on 12/5/15.
//  Copyright © 2015 Pelfunc, Inc. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  @IBOutlet weak var choiceButton: UIButton!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
