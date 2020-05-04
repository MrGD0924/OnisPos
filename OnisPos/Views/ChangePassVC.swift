//
//  ChangePassVC.swift
//  OnisPos
//
//  Created by MG on 4/19/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePassVC: UIViewController {

    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtNewAgain: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        setBorderText(txtOldPass)
        setBorderText(txtNewPass)
        setBorderText(txtNewAgain)
        
        let imgPass = UIImage(named:"password")
        addLeftImageTo(txtField: txtOldPass, andImage: imgPass!)
        addLeftImageTo(txtField: txtNewPass, andImage: imgPass!)
        addLeftImageTo(txtField: txtNewAgain, andImage: imgPass!)
    }

    @IBAction func btnCance(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if txtNewPass.text!.isEmpty || txtNewAgain.text!.isEmpty || txtOldPass.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Хоосон талбаруудыг бөглөнө үү!")
            return
        }
        
        if txtNewPass.text != txtNewAgain.text {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Дахин оруулсан нууц үг буруу байна!")
            return
        }
        
        if txtNewPass.text!.count < 4 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Нууц үг хамгийн багадаа 4 оронтой байх ёстой!")
            return
        }
        
        let parameter = [
            "userName": userName,
            "oldPassword": txtOldPass.text!,
            "newPassword": txtNewPass.text!
        ] as [String : Any]
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        networkingClient.executePost(_suburl: API_CHANGE_PASSWORD, parameters: parameter) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if(isSuccess == true){
                    self.okAction(title: "Анхаар", message: message)
                }
                else{
                    showAlertAction(view: self, title: "Анхаар", message: message)
                }
            }
        }
    }
    
    
    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
