//
//  ViewController.swift
//  OnisPos
//
//  Created by MG on 4/6/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var switchSave: UISwitch!
    @IBOutlet weak var lblNewuser: UILabel!
    @IBOutlet weak var lblForget: UILabel!
    @IBOutlet weak var lblBeta: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        SVProgressHUD.setDefaultMaskType(.clear)
        self.navigationController?.navigationBar.barTintColor = myOrangeColor
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
        
        let imgUser = UIImage(named:"user")
        let imgPass = UIImage(named:"password")
        
        addLeftImageTo(txtField: txtUsername, andImage: imgUser!)
        addLeftImageTo(txtField: txtPassword, andImage: imgPass!)
        
        txtUsername.text = UserDefaults.standard.string(forKey: "userName")
        UserDefaults.standard.set("", forKey: "token")
        
        ReloadDistrict()
        ReloadCategory()
        UnderLine(label: lblNewuser, txt: "Шинээр бүртгүүлэх")
        UnderLine(label: lblForget, txt: "Нууц үг/Нэвтрэх дугаар мартсан")
        UnderLine(label: lblBeta, txt: "Туршилтын хувилбар")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "буцах"
        navigationItem.backBarButtonItem = backItem
    }
    
    func UnderLine(label: UILabel, txt: String){
        let underlineAttriString = NSAttributedString(string: txt,
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = underlineAttriString
    }

    @IBAction func btnLogin_click(_ sender: UIButton) {
        loginAction(txtUsername.text!, txtPassword.text!)
    }
    
    @IBAction func btnForget(_ sender: Any) {
        self.performSegue(withIdentifier: "seguePass", sender: self)
    }
    
    @IBAction func txtUsername_editing(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 6)
    }
    
    func loginAction(_ user: String,_ password: String){
        if user.isEmpty || password.isEmpty {
            showAlertAction(view: self, title: "Анхаар", message: "Нэр, нууц үгээ оруулна уу!")
            return
        }
        
        let parameter = [
            "userName": user,
            "password": password,
            "imeCode": UIDevice.current.identifierForVendor!.uuidString
        ] as [String : Any]
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        networkingClient.executePost(_suburl: API_LOGIN, parameters: parameter) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"].array
                    if user != "demo" {
                        if(self.switchSave.isOn){
                            UserDefaults.standard.set(user, forKey: "userName")
                        }
                        else{
                            UserDefaults.standard.set(nil, forKey: "userName")
                        }
                    }

                    selectedMenuItem = 0
                    storeName = data![0]["storeName"].stringValue
                    userName = user
                    isLicensed = data![0]["isLicensed"].boolValue
                    licenceText = data![0]["licenceText"].stringValue
                    versionNum = data![0]["ios"].stringValue
                    bannerImage = data![0]["bannerImage"].stringValue
                    updateInfo = data![0]["updateInfoText"].stringValue
                    
                    UserDefaults.standard.set(data![0]["token"].string, forKey: "token")
                    UserDefaults.standard.set(data![0]["userID"].int, forKey: "userID")
                    UserDefaults.standard.set(data![0]["storeId"].int, forKey: "storeId")
                    UserDefaults.standard.set(data![0]["leftDate"].int, forKey: "leftDate")
                    
                    let store = data![0]["store"]
                    let phonenum = String(store["phonenum"].intValue)
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
                    let storeInfo = StoreInfo(storename, regnum, dealernum, isvatpayer, distcode, vatpercent, phonenum, citytaxpercent, classcode, email, address, ownername, storeid)
                    storeInformation = storeInfo
                    
                    self.performSegue(withIdentifier: "segueMain", sender: self)
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Анхаар", message: message)
                }
            }
        }
    }
    
    @IBAction func btnBeta_click(_ sender: UIButton) {
        loginAction("demo", "demo")
    }
}

