//
//  ReportDayVC.swift
//  OnisPos
//
//  Created by MG on 4/19/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportDayVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSum: UILabel!
    
    var listMain:[DayReport] = []
    var yearList:[Int] = []
    var monthList:[Int] = [1,2,3,4,5,6,7,8,9,10,11,12]
    var total = 0
    var totalCount = 0
    var selectedYear: String?
    var selectedMonth: String?
    var selectedTag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView(txtYear, 0)
        createPickerView(txtMonth, 1)
        dismissPickerView(txtYear)
        dismissPickerView(txtMonth)
        createValue()
        
        reloadData()
    }
    
    func createValue() {
        let year = Calendar.current.component(.year, from: Date())
        yearList = [year , year - 1, year - 2, year - 3, year - 4, year - 5, year - 6]
        txtYear.text = String(year)
        selectedYear = String(year)
        
        let month = Calendar.current.component(.month, from: Date())
        txtMonth.text = String(month)
        selectedMonth = String(month)
    }
    
    func createPickerView(_ text: UITextField,_ tag: Int) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        text.inputView = pickerView
    }
    func dismissPickerView(_ text: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Сонгох", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        text.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if selectedTag == 0 {
            txtYear.text = selectedYear
        }
        else{
            txtMonth.text = selectedMonth
        }
        reloadData()
        view.endEditing(true)
    }
    
    func reloadData() {
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
        listMain.removeAll()
        self.total = 0
        self.totalCount = 0
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let yearM = selectedYear! + "-" + selectedMonth!
        let suburl = API_GET_REPORT_DAY + "\(userId)/\(yearM)-01"
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
                        let item = DayReport(row["sequence"].int, row["amount"].int, row["count"].int, false)
                        self.total = self.total + item.amount!
                        self.totalCount = self.totalCount + item.count!
                        self.listMain.append(item)
                    })
                    self.tableMain.reloadData()
                    self.lblTotal.text = numberFormat2(number: self.total)
                    self.lblSum.text = numberFormat2(number: self.totalCount)
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listMain.count
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listMain[section].expand == true {
            return listMain[section].count! + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportHeaderTVCell") as! ReportHeaderTVCell
            cell.lblDay.text = String(self.listMain[indexPath.section].name!)
            cell.lblAmount.text = "₮" + numberFormat2(number: self.listMain[indexPath.section].amount!)
            cell.lblCount.text = String(self.listMain[indexPath.section].count!)
            let date = self.selectedYear! + "/" + self.selectedMonth! + "/\(cell.lblDay.text!)"
            let dateName = self.getDateName(date)
            cell.lblDate.text = dateName
            if self.listMain[indexPath.section].count! > 0 {
                if(self.listMain[indexPath.section].expand == false){
                    cell.imgExpand.image = UIImage(named: "collapse")
                }
                else {
                    cell.imgExpand.image = UIImage(named: "expand")
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDetailTVCell") as! ReportDetailTVCell
            cell.lblSlsnum.text = self.listMain[indexPath.section].listData![dataIndex].slsnum!
            var time = self.listMain[indexPath.section].listData![dataIndex].slstime!
            cell.lblSlstime.text = time.substring(with:11..<16)
            cell.lblAmount.text = numberFormat2(number: self.listMain[indexPath.section].listData![dataIndex].amount!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if listMain[indexPath.section].expand == true {
                listMain[indexPath.section].expand = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                if(listMain[indexPath.section].count! > 0){
                    if listMain[indexPath.section].listData == nil {
                        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү...")
                        
                        let userId = UserDefaults.standard.integer(forKey: "userID")
                        let yearM = selectedYear! + "-" + selectedMonth!
                        let suburl = API_GET_REPORT_DAY_DETAIL + "\(userId)/\(yearM)-\(listMain[indexPath.section].name!)"
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
                                    var list:[DayDetail] = []
                                    data?.forEach({ (row) in
                                        let item = DayDetail(row["slsnum"].stringValue, row["slstime"].stringValue, row["amount"].int)
                                        list.append(item)
                                    })
                                    self.listMain[indexPath.section].listData = list
                                    self.listMain[indexPath.section].expand = true
                                    let sections = IndexSet.init(integer: indexPath.section)
                                    tableView.reloadSections(sections, with: .none)
                               }
                               else{
                                   let message = String(json["message"].string!)
                                   showAlertAction(view: self, title: "Алдаа", message: message)
                               }
                           }
                        }
                    }
                    else {
                        self.listMain[indexPath.section].expand = true
                        let sections = IndexSet.init(integer: indexPath.section)
                        tableView.reloadSections(sections, with: .none)
                    }
                }
               
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return yearList.count
        }
        else{
            return monthList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return String(yearList[row])
        }
        else{
            return String(monthList[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTag = pickerView.tag
        if pickerView.tag == 0{
            selectedYear = String(yearList[row])
        }
        else{
            selectedMonth = String(monthList[row])
        }
    }
    
    func getDateName(_ date: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: someDateTime!)
        switch dayInWeek {
        case "Sunday":
            return "Ня"
        case "Monday":
            return "Да"
        case "Tuesday":
            return "Мя"
        case "Wednesday":
            return "Лх"
        case "Thursday":
            return "Пү"
        case "Friday":
            return "Ба"
        case "Saturday":
            return "Бя"
        default:
            return ""
        }
    }

}
