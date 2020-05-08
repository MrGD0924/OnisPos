//
//  ForgetPassVC.swift
//  OnisPos
//
//  Created by MG on 4/29/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgetPassVC: UIViewController {

    @IBOutlet weak var txtRegnum: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setBorderText(txtRegnum)
        self.title = "Нууц үг сэргээх"
        
        let imgUser = UIImage(named:"user")
        addLeftImageTo(txtField: txtRegnum, andImage: imgUser!)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        if txtRegnum.text!.count == 7 || txtRegnum.text!.count == 10 {
            SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
            
            let reg = String(utf8String: txtRegnum.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            networkingClient.executePost(_suburl: API_GET_ALL_USER + reg!, parameters: [:]) { (json, error) in
               SVProgressHUD.dismiss()
               if let error = error {
                   showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
               }
               else if let json = json {
                   let isSuccess = json["success"]
                   if(isSuccess == true){
                        var listMain: [User] = []
                        let data = json["value"].array
                        data?.forEach({ (row) in
                            let item = User(row["userid"].intValue, row["username"].stringValue, String(row["phonenum"].intValue), false)
                            listMain.append(item)
                        })
                        let vc = ForgetPopupVC(nibName: "ForgetPopupVC", bundle: nil)
                        vc.listAll = listMain
                        vc.returnValue = {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 415))
                        self.present(form, animated: true, completion: nil)
                   }
                   else{
                       let message = String(json["message"].string!)
                       showAlertAction(view: self, title: "Алдаа", message: message)
                   }
               }
            }
        }
        else {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Та регистрийн дугаараа зөв оруулна уу!")
        }
    }
    @IBAction func txtChanging(_ sender: UITextField) {
        txtRegnum.text = txtRegnum.text!.uppercased()
        checkMaxLength(textField: sender, maxLength: 10)
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
