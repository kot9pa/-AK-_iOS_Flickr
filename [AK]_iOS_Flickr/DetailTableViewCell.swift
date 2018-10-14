//
//  DetailTableViewCell.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 10.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    //TODO: - Will attempt to recover by breaking constraint
    //<NSLayoutConstraint: UIImageView:.height == 150   (active)>
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var brandTitle: UILabel!
    @IBOutlet weak var megaPixels: UILabel!
    @IBOutlet weak var screenSize: UILabel!
    @IBOutlet weak var memoryType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
