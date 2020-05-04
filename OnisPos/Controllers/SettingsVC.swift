//
//  SettingsVC.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class SettingsVC: BaseViewController {

    @IBOutlet weak var txtDealer: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtVat: UITextField!
    @IBOutlet weak var switchVat: UISwitch!
    @IBOutlet weak var lblDistrict: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtOwner: UITextField!
    @IBOutlet weak var txtRegnum: UITextField!
    @IBOutlet weak var txtStorename: UITextField!
    @IBOutlet weak var txtClass: UITextField!
    
    var district: District? = nil
    var classs: Classs? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Тохиргоо"
        hideKeyboardWhenTappedAround()
        addSlideMenuButton(false)
        ReloadDistrict()
        ReloadCategory()

        setBorderText(txtVat)
        setBorderText(txtClass)
        setBorderText(txtEmail)
        setBorderText(txtOwner)
        setBorderText(txtDealer)
        setBorderText(txtPhone)
        setBorderText(txtRegnum)
        setBorderText(txtStorename)
        setBorderText(lblDistrict)
        setBorderText2(txtAddress)
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setData() {
        txtStorename.text = storeInformation!.storename
        txtAddress.text = storeInformation!.address
        txtRegnum.text = storeInformation!.regnum
        txtDealer.text = storeInformation!.dealernum
        txtPhone.text = storeInformation!.phonenum
        txtEmail.text = storeInformation!.email
        txtOwner.text = storeInformation!.ownername
        txtVat.text = String(storeInformation!.vatpercent!)
        if storeInformation!.isvatpayer == 1 {
            switchVat.isOn = true
        }
        
        if let row =  listClass.first(where: {$0.classcode == storeInformation!.classcode}){
            self.classs = row
            self.txtClass!.text = row.classname
        }
        
        if let row =  listDistrict.first(where: {$0.distcode == storeInformation!.distcode!}){
            self.district = row
            self.lblDistrict!.text = row.distname
        }
        
        if txtDealer.text!.count > 0 {
            txtDealer.isEnabled = false
        }
    }
    
   
    
    @IBAction func btnClear(_ sender: UIButton) {
        setData()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if txtStorename.text!.isEmpty || txtOwner.text!.isEmpty || txtPhone.text!.isEmpty || lblDistrict.text!.isEmpty || txtAddress.text!.isEmpty{
            showAlertAction(view: self, title: "Мэдээлэл", message: "Хоосон талбаруудыг бөглөнө үү!")
            return
        }
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let parameters: Parameters = [
            "storeid": storeInformation!.storeid,
            "storename": txtStorename.text!,
            "regnum": txtRegnum.text!,
            "ownername": txtOwner.text!,
            "phonenum": txtPhone.text!,
            "email": txtEmail.text!,
            "distcode": district!.distcode,
            "isvatpayer": switchVat.isOn ? 1: 0,
            "vatpercent": switchVat.isOn ? 10 : 0,
            "classcode": classs!.classcode,
            "address": txtAddress.text!,
            "userid": userId,
            "dealernum": txtDealer.text!,
       ]
        
        SVProgressHUD.show()
        networkingClient.executePut(_suburl: API_UPDATE_STORE, parameters: parameters) { (json, error) in
            SVProgressHUD.dismiss()
             if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
             }
             else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if isSuccess == true {
                    storeInformation!.storename = self.txtStorename.text!
                    storeInformation!.ownername = self.txtOwner.text!
                    storeInformation!.phonenum = self.txtPhone.text!
                    storeInformation!.email = self.txtEmail.text!
                    storeInformation!.distcode = self.district!.distcode
                    storeInformation!.classcode = self.classs!.classcode
                    storeInformation!.address = self.txtAddress.text!
                    storeInformation!.dealernum = self.txtDealer.text!
                }
                showAlertAction(view: self, title: "Алдаа", message: message)
            }
        }
    }
    
    @IBAction func btnPassChange(_ sender: UIButton) {
        let vc = ChangePassVC(nibName: "ChangePassVC", bundle: nil)
       
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 276))
        self.present(form, animated: true, completion: nil)
    }

    @IBAction func btnClass(_ sender: UIButton) {
        let vc = PopupVC(nibName: "PopupVC", bundle: nil)
        vc.type = 2
        vc.returnCategory = {(data) in
           self.classs = data
           self.txtClass.text = data.classname
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 500))
        self.present(form, animated: true, completion: nil)
    }
    
    @IBAction func btnDistrict(_ sender: UIButton) {
        let vc = PopupVC(nibName: "PopupVC", bundle: nil)
        vc.type = 1
        vc.returnDistrict = {(data) in
            self.district = data
            self.lblDistrict.text = data.distname
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 500))
        self.present(form, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    if(txtDealer.isEditing || txtAddress.isFirstResponder ){
                      self.view.frame.origin.y -= keyboardSize.height
                  }
              }
          }
      }
      
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
          self.view.frame.origin.y = 0
        }
    }
}
