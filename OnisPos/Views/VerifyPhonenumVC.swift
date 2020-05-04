//
//  VerifyPhonenumVC.swift
//  OnisPos
//
//  Created by MG on 4/24/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class VerifyPhonenumVC: UIViewController {
    var returnValue: ((String)->())?

    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        setBorderText(txtPhone)
        txtPhone.text = storeInformation!.phonenum
    }

    @IBAction func txtPhone_check(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 8)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        self.returnValue!(txtPhone.text!)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
