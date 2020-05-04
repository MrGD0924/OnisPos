//
//  LicenceVerifyVC.swift
//  OnisPos
//
//  Created by MG on 4/23/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class LicenceVerifyVC: BaseViewController {

    @IBOutlet weak var lblAcc: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgQpay: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    
    var isUnit = false
    var textTotal = ""
    var url: String = ""
    var phoneNum = ""
    var isConfirm = false
    var type = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(false)
        
        if isUnit {
            lblText.text = ""
            lblBank.text = ""
            lblText2.text = "УТАСНЫ ДУГААР"
            getConfirmNumber()
        }
        else{
            getQRData()
        }
        
        lblUsername.text = userName
        lblTotal.text = textTotal
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: UIButton) {
        if isUnit {
            if isConfirm {
                sendLicence()
            }
            else {
                let vc = VerifyPhonenumVC(nibName: "VerifyPhonenumVC", bundle: nil)
                vc.returnValue = {(phone) in
                    self.VerifyNum(phone)
                }
                let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 360))
                form.allowDismissByPanningPresentedView = false
                self.present(form, animated: true, completion:  nil)
            }
        }
        else {
            if(imgQpay.image != nil){
                let link = NSURL(string: url)!
                UIApplication.shared.openURL(link as URL)
            }
        }
    }
    
    func getConfirmNumber() {
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү..")
        let suburl = API_CONFIRM_PHONE + userName
        networkingClient.executeGet(_suburl: suburl, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"]
                    self.isConfirm = data["isConfrim"].boolValue
                    self.phoneNum = data["phoneNum"].stringValue
                    var confirmText = "Баталгаажаагүй"
                    if self.isConfirm {
                        confirmText = "Баталгаажсан"
                    }
                    self.lblAcc.text = self.phoneNum + "/" + confirmText + "/"
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func VerifyNum(_ phone: String) {
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү..")
        let suburl = API_CONFIRM_NUMBER + userName + "/" + phone
        networkingClient.executePost(_suburl: suburl, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"]
                    let vc = VerifyTanVC(nibName: "VerifyTanVC", bundle: nil)
                    vc.phoneNum = phone
                    vc.returnValue = {
                        self.sendLicence()
                    }
                    let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 295))
                    self.present(form, animated: true, completion: nil)
                           
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func sendLicence(){

        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        let amount = Int(stringNumber(value: lblTotal.text!))!
        let suburl = API_LICENCE_MOBILE + userName + "/\(amount)/\(type)"
        print(suburl)
        networkingClient.executePost(_suburl: suburl, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if(isSuccess == true){
                    self.okAction(title: "Мэдээлэл", message: message)
                    print(json["value"])
                }
                else{
                    showAlertAction(view: self, title: "Анхаар", message: message)
                }
            }
        }
    }
    
    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.performSegue(withIdentifier: "segueLic", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getQRData(){
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        var amount = stringNumber(value: textTotal)
        
        networkingClient.executePost(_suburl: API_INSERT_LICENSE_BY_QR_CODE + String(amount), parameters: [:]) { (json, error) in
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
                SVProgressHUD.dismiss()
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"]
                    self.url = data["qPay_url"].string!
                    let strBase64 = data["qPay_QRimage"].string
                    let dataDecoded:NSData = NSData(base64Encoded: strBase64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                    self.imgQpay.image = decodedimage
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Анхаар", message: message)
                }
                
                SVProgressHUD.dismiss()
            }
        }
    }
}
