//
//  ReturnVC.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReturnVC: BaseViewController {

    @IBOutlet weak var txtBillNum: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtDDTD: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Буцаалт"
        addSlideMenuButton(false)
        hideKeyboardWhenTappedAround()

        setBorderText(txtBillNum)
        setBorderText(txtDate)
        setBorderText(txtDDTD)
        setBorderText(txtAmount)
        
        lblUsername.text = storeName
        lblDate.text = getCurrentDate()
    }
    
    @IBAction func btnLoad(_ sender: UIButton) {
        if txtBillNum.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Буцаах баримтын дугаараа зөв оруулна уу!")
            return
        }
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let bill = txtBillNum.text!

        networkingClient.executePost(_suburl: API_RETURN_SALE_INFO + bill + "/" + "\(userId)", parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"]
                    self.txtDate.text = data["date"].stringValue
                    self.txtDDTD.text = data["returnBillId"].stringValue
                    self.txtAmount.text = numberFormat2(number: data["amount"].intValue)
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    @IBAction func txtBillnum_changed(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 12)
    }
    
    @IBAction func btnReturn_click(_ sender: UIButton) {
        
        if txtBillNum.text!.isEmpty  || txtDDTD.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Буцаах баримтын дугаараа зөв оруулна уу!")
            return
        }
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let bill = txtBillNum.text!
        let imei = UIDevice.current.identifierForVendor!.uuidString
        
        networkingClient.executePost(_suburl: API_RETURN_SALE + bill + "/" + "\(userId)/" + imei, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if(isSuccess == true){
                    self.txtAmount.text = ""
                    self.txtBillNum.text = ""
                    self.txtDDTD.text = ""
                    self.txtDate.text = ""
                    showAlertAction(view: self, title: "Мэдээлэл", message: message)
                }
                else{
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
}
