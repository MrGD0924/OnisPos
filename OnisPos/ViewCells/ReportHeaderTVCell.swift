//
//  ReportHeaderTVCell.swift
//  OnisPos
//
//  Created by MG on 4/26/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class ReportHeaderTVCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgExpand: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
