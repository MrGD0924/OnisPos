//
//  ReportYearVC.swift
//  OnisPos
//
//  Created by MG on 4/19/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportYearVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableMain: UITableView!
    var listMain:[Report] = []
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
    }
    
    func reloadData() {
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        self.total = 0
        let userId = UserDefaults.standard.integer(forKey: "userID")
        networkingClient.executeGet(_suburl: API_GET_REPORT_YEAR + "\(userId)", parameters: [:]) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"].array
                    data?.forEach({ (row) in
                        let item = Report(row["sequence"].int, row["amount"].int)
                        self.total = self.total + item.amount!
                        self.listMain.append(item)
                    })
                    self.tableMain.reloadData()
                    self.lblTotal.text = numberFormat2(number: self.total)
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTVCell") as! ReportTVCell
        cell.lblText.text = String(self.listMain[indexPath.row].name!)
        cell.lblTotal.text = numberFormat2(number: self.listMain[indexPath.row].amount!)
        return cell
    }
    


}
