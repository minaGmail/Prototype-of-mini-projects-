//
//  repoCell.swift
//  task
//
//  Created by Mina Gamil  on 12/24/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import UIKit

class repoCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var repoDescription: UITextView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var repoOwner: UILabel!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.frame.height*0.1
        containerView.clipsToBounds = true
        repoDescription.backgroundColor = UIColor.clear
        repoOwner.backgroundColor = UIColor.clear
        repoName.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
