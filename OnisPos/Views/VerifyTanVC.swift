//
//  VerifyTanVC.swift
//  OnisPos
//
//  Created by MG on 4/25/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class VerifyTanVC: UIViewController {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var txtTan: UITextField!
    var phoneNum = ""
    var returnValue: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        setBorderText(txtTan)
        hideKeyboardWhenTappedAround()
        lblText.text = "***Та \(phoneNum) дугаарт ирсэн 5 оронтой кодыг оруулж баталгаажуулалт хийнэ үү!"
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        if txtTan.text!.isEmpty || txtTan.text!.count != 5 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Та кодоо оруулна уу!")
            return
        }
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү..")
        let suburl = API_VERIFY_TAN + userName + "/" + txtTan.text!
        networkingClient.executePost(_suburl: suburl, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if(isSuccess == true){
                    let data = json["value"]
                    self.okAction(title: "Мэдээлэл", message: message)       
                }
                else{
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
        
    }
    
    @IBAction func txtCheck(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 5)
    }

    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.returnValue!()
            self.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
