//
//  ForgetPopupVC.swift
//  OnisPos
//
//  Created by MG on 4/29/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgetPopupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableMain: UITableView!
    var listAll:[User] = []
    var selectedUser = ""
    var returnValue: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableMain.delegate = self
        tableMain.dataSource = self
        
        let nibName = UINib(nibName: "ForgetCellTVCell", bundle: nil)
        tableMain.register(nibName, forCellReuseIdentifier: "ForgetCellTVCell")
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        if selectedUser.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Та нэвтрэх дугаараа сонгоно уу!")
            return
        }
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        networkingClient.executePost(_suburl: API_SEND_RESET_PASS + selectedUser, parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                let message = String(json["message"].string!)
                if(isSuccess == true){
                    self.okAction(title: "Мэдээлэл", message: message)
                }
                else{
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.returnValue!()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForgetCellTVCell") as! ForgetCellTVCell
        cell.lblUsername.text = self.listAll[indexPath.row].username
        cell.lblPhone.text = self.listAll[indexPath.row].phonenum
        if self.listAll[indexPath.row].check! {
            cell.imgCheck.image = UIImage(named: "check")
        }
        else {
            cell.imgCheck.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = self.listAll[indexPath.row].username!
        for (index, element) in listAll.enumerated() {
            print(index)
            print(indexPath.row)
            if index == indexPath.row {
                self.listAll[index].check = true
            }
            else {
                self.listAll[index].check = false
            }
        }
        tableMain.reloadData()
    }

}
