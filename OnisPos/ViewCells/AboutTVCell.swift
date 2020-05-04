//
//  AboutTVCell.swift
//  OnisPos
//
//  Created by MG on 4/16/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class AboutTVCell: UITableViewCell {

    @IBOutlet weak var imgDrop: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var btnDrop: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
