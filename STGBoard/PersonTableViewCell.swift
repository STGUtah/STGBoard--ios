//
//  PersonTableViewCell.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import RAMPaperSwitch

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkedInSwitch: RAMPaperSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        checkedInSwitch.animationDidStartClosure = { on in self.animateLabel(self.nameLabel, onAnimation: on, duration: self.checkedInSwitch.duration) }
        checkedInSwitch.animationDidStopClosure = { on, finished in self.animateLabel(self.nameLabel, onAnimation: on, duration: self.checkedInSwitch.duration) }
    }
    
    var person: Person? {
        didSet{
            guard let person = person else { return }
            nameLabel.text = person.fullName
            checkedInSwitch.isOn = person.isInOffice
        }
    }
    
    fileprivate func animateLabel(_ label: UILabel, onAnimation: Bool, duration: TimeInterval) {
        UIView.transition(with: label, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            label.textColor = onAnimation ? UIColor.white : nil
        }, completion:nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func checkedInSwitchValueChanged(_ sender: Any) {
        
    }
}


protocol PersonTableViewCellDelegate: class {
    func didChangePersonCheckedInStatus(_ person: Person, cell: PersonTableViewCell)
}
