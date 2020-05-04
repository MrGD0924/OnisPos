//
//  ReportDetailTVCell.swift
//  OnisPos
//
//  Created by MG on 4/26/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class ReportDetailTVCell: UITableViewCell {

    @IBOutlet weak var lblSlsnum: UILabel!
    @IBOutlet weak var lblSlstime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
