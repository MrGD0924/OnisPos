//
//  ReportMonthVC.swift
//  OnisPos
//
//  Created by MG on 4/19/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportMonthVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    var listMain:[Report] = []
    var total = 0
    var selectedYear: String?
    var yearList:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        createYear()
        createPickerView()
        dismissPickerView()
        reloadData()
    }
    func createYear() {
        let year = Calendar.current.component(.year, from: Date())
        yearList = [year , year - 1, year - 2, year - 3, year - 4, year - 5, year - 6]
        txtYear.text = String(year)
        selectedYear = String(year)
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtYear.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Сонгох", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtYear.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        txtYear.text = selectedYear
        reloadData()
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportMonthTVCell") as! ReportMonthTVCell
        cell.lblText.text = String(self.listMain[indexPath.row].name!)
        cell.lblAmount.text = numberFormat2(number: self.listMain[indexPath.row].amount!)
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearList.count // number of dropdown items
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearList[row]) // dropdown item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = String(yearList[row])
    }
    
    func reloadData() {
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        listMain.removeAll()
        self.total = 0
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let year = selectedYear!
        let suburl = API_GET_REPORT_MONTH + "\(userId)/\(year)-01-01"
        print(suburl)
        networkingClient.executeGet(_suburl: suburl, parameters: [:]) { (json, error) in
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
}
