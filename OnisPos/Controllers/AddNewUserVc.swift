//
//  AddNewUserVc.swift
//  OnisPos
//
//  Created by MG on 4/15/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import HandyJSON

@available(iOS 10.0, *)
class AddNewUserVc: UIViewController, UITextFieldDelegate {
    
    var isOK = false
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var isVatPayer = 0
    var store = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = false

        let imgUser = UIImage(named:"user")
        let imgPass = UIImage(named:"password")
        let imgPhone = UIImage(named:"phone")
        
        addLeftImageTo(txtField: txtUsername, andImage: imgUser!)
        addLeftImageTo(txtField: txtPassword, andImage: imgPass!)
        addLeftImageTo(txtField: txtPhone, andImage: imgPhone!)
        
        setBorderText(txtUsername)
        setBorderText(txtPhone)
        setBorderText(txtPassword)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        newStoreInfo = nil
    }
    
    @IBAction func btnNext_click(_ sender: UIButton) {
        if !isOK {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Бүртгэлгүй регистрийн дугаар оруулсан байна!")
            return
        }
        
        if txtPhone.text!.isEmpty || txtUsername.text!.isEmpty || txtPassword.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Хоосон талбаруудыг бөглөнө үү!")
            return
        }
        
        if(txtPassword.text!.count < 4){
            showAlertAction(view: self, title: "Мэдээлэл", message: "Нууц үг хамгийн багадаа 4 оронтой байх ёстой!")
            return
        }
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AddNewApproveVC") as! AddNewApproveVC
        vc.regnum = txtUsername.text!
        vc.phonenum = txtPhone.text!
        vc.password = txtPassword.text!
        vc.isVatpayer = self.isVatPayer
        vc.storename = self.store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCancel_click(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnReg_changed(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 10)
        txtUsername.text = txtUsername.text!.uppercased()
    }
    
    @IBAction func txtPhone_changing(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 8)
    }
    
    @IBAction func btnPass_changed(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 10)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
         
        if txtUsername.text!.count == 7 || txtUsername.text!.count == 10 {
           SVProgressHUD.show()
           
           let reg = String(utf8String: txtUsername.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            networkingClient.executeGet(_suburl: API_GET_STORE_INFO + reg!, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
               if let error = error {
                   showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
               }
               else if let json = json {
                   let isSuccess = json["success"]
                   if(isSuccess == true){
                        self.isOK = true
                        let store = json["value"]
                        let citytaxpercent = store["citytaxpercent"].intValue
                        let storeid = store["storeid"].intValue
                        let email = store["email"].stringValue
                        let vatpercent = store["vatpercent"].intValue
                        let dealernum = store["dealernum"].stringValue
                        let address = store["address"].stringValue
                        let isvatpayer = store["isvatpayer"].intValue
                        let regnum = store["regnum"].stringValue
                        let classcode = store["classcode"].stringValue
                        let storename = store["storename"].stringValue
                        let ownername = store["ownername"].stringValue
                        let distcode = store["distcode"].stringValue
                        let storeInfo = StoreInfo(storename, regnum, dealernum, isvatpayer, distcode, vatpercent, "", citytaxpercent, classcode, email, address, ownername, storeid)
                        newStoreInfo = storeInfo
                   }
                   else{
                        self.checkRegnum()
                   }
               }
           }
        }
        else {
            isOK = false
            newStoreInfo = nil
            if txtUsername.text!.count != 0 {
                showAlertAction(view: self, title: "Мэдээлэл", message: "Pегистрийн дугаар буруу байна!")
            }
        }
    }
    
    func checkRegnum() {
        SVProgressHUD.show()
        newStoreInfo = nil
        let reg = String(utf8String: txtUsername.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
         networkingClient.executePut(_suburl: API_CHECK_REG_NUM + reg!, parameters: [:]) { (json, error) in
         SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                     self.isOK = true
                    let data = json["value"].stringValue
                    if let user = [NewUser].deserialize(from: data) {
                        self.store = user[0]!.STORENAME!
                        self.isVatPayer = user[0]!.ISVATPAYER!
                    }
                }
                else{
                     let message = String(json["message"].string!)
                     showAlertAction(view: self, title: "Анхаар", message: message)
                }
            }
        }
    }
}

class NewUser: HandyJSON {
    var STORENAME: String?
    var ISVATPAYER: Int?
    required init() {}
}
