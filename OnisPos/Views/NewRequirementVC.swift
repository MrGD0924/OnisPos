//
//  NewRequirementVC.swift
//  OnisPos
//
//  Created by MG on 5/6/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class NewRequirementVC: UIViewController {

    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var chkOK: UISwitch!
    var returnOk: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func chk_check(_ sender: UISwitch) {
        if chkOK.isOn {
            btnYes.backgroundColor = myOrangeColor
        }
        else {
            btnYes.backgroundColor = myBlackColor
        }
    }
    
    @IBAction func btn_OK(_ sender: UIButton) {
        if chkOK.isOn {
            returnOk!()
            dismiss(animated: true, completion: nil)
        }
        
    }

}
