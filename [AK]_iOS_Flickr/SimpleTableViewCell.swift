//
//  SimpleTableViewCell.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 10.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    //TODO: - Will attempt to recover by breaking constraint
    //<NSLayoutConstraint: UIImageView:.height == 80   (active)>
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var brandTitle: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
