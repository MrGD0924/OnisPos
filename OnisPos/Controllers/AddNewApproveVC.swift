//
//  AddNewApproveVC.swift
//  OnisPos
//
//  Created by MG on 4/16/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AddNewApproveVC: UIViewController {

    @IBOutlet weak var txtStorename: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtRegnum: UITextField!
    @IBOutlet weak var txtOwner: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDistrict: UITextField!
    @IBOutlet weak var txtVat: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtSaler: UITextField!
    @IBOutlet weak var switchVat: UISwitch!
    
    var district: District? = nil
    var classs: Classs? = nil
    
    var regnum = ""
    var phonenum = ""
    var password = ""
    var storeId = 0
    var isVatpayer = 0
    var storename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        ReloadDistrict()
        ReloadCategory()
        setBorderText(txtVat)
        setBorderText(txtCategory)
        setBorderText(txtEmail)
        setBorderText(txtOwner)
        setBorderText(txtSaler)
        setBorderText(txtPhone)
        setBorderText(txtRegnum)
        setBorderText(txtStorename)
        setBorderText(txtDistrict)
        setBorderText2(txtAddress)
        
        txtPhone.text = phonenum
        
        if newStoreInfo != nil {
            setData()
        }
        else{
            txtStorename.text = storename
            if isVatpayer == 1 {
                switchVat.isOn = true
                txtVat.text = "10"
            }
            else{
                txtVat.text = "0"
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setData() {
        storeId = newStoreInfo!.storeid!
        txtStorename.text = newStoreInfo!.storename
        txtRegnum.text = newStoreInfo!.regnum
        txtOwner.text = newStoreInfo!.ownername
        txtEmail.text = newStoreInfo!.email
        txtVat.text = String(newStoreInfo!.vatpercent!)
        txtAddress.text = newStoreInfo!.address
        if newStoreInfo!.isvatpayer == 1 {
            switchVat.isOn = true
        }
       
        if let row =  listClass.first(where: {$0.classcode == newStoreInfo!.classcode}){
            self.classs = row
            self.txtCategory!.text = row.classname
        }
       
        if let row =  listDistrict.first(where: {$0.distcode == newStoreInfo!.distcode!}){
            self.district = row
            self.txtDistrict!.text = row.distname
        }
    }
    
    @IBAction func btnBack_click(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func txtDone_click(_ sender: UIButton) {
        if txtStorename.text!.isEmpty || txtOwner.text!.isEmpty || txtPhone.text!.isEmpty || txtDistrict.text!.isEmpty || txtAddress.text!.isEmpty{
             showAlertAction(view: self, title: "Мэдээлэл", message: "Хоосон талбаруудыг бөглөнө үү!")
             return
         }
        
         let parameters: Parameters = [
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
             "dealernum": txtSaler.text!,
             "password": password,
             "storeid": storeId,
        ]
         
         SVProgressHUD.show()
         networkingClient.executePut(_suburl: API_INSERT_STORE, parameters: parameters) { (json, error) in
             SVProgressHUD.dismiss()
              if let error = error {
                 showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
              }
              else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if isSuccess == true {
                    
                    let id = json["value"].string
                    UserDefaults.standard.set(id, forKey: "userName")
                    self.okAction(title: "Амжилттай", message: message)
                }
                else {
                     showAlertAction(view: self, title: "Алдаа", message: message)
                }
             }
         }
    }
    
    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
               self.performSegue(withIdentifier: "segueLogin", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnClass(_ sender: UIButton) {
        let vc = PopupVC(nibName: "PopupVC", bundle: nil)
        vc.type = 2
        vc.returnCategory = {(data) in
            self.classs = data
            self.txtCategory.text = data.classname
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 500))
        self.present(form, animated: true, completion: nil)
    }
    
    @IBAction func btnDistrict(_ sender: UIButton) {
        let vc = PopupVC(nibName: "PopupVC", bundle: nil)
        vc.type = 1
        vc.returnDistrict = {(data) in
            self.district = data
            self.txtDistrict.text = data.distname
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 500))
        self.present(form, animated: true, completion: nil)
    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    if(txtSaler.isEditing || txtAddress.isFirstResponder ){
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
