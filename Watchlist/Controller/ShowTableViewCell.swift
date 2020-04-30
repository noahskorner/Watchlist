//
//  ShowTableViewCell.swift
//  Watchlist
//
//  Created by Noah Korner on 4/7/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
        imgView.layer.cornerRadius = 10
        imgView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        imgView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
