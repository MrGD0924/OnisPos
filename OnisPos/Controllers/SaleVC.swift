//
//  SaleVC.swift
//  OnisPos
//
//  Created by MG on 4/8/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit


class SaleVC: BaseViewController{
    
    @IBOutlet weak var lblStorename: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    var totalAmount = 0
    var value = 0
    var currentSymbolTag = 0
    var isSymbolClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addSlideMenuButton(true)
        getDuration()
        
        self.navigationController?.isNavigationBarHidden = false
        
        lblStorename.text = storeName
        lblDate.text = getCurrentDate()
        
        if isLicensed == false && userName != "demo" {
            let vc = LicenceTextVC(nibName: "LicenceTextVC", bundle: nil)
            vc.returnValue = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                   self.performSegue(withIdentifier: "seguePay", sender: self)
                }
            }
            let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 340))
            self.present(form, animated: true, completion: nil)
        }
        
        checkMyVersion()
    }

    @IBAction func btnPay(_ sender: UIButton) {
        if currentSymbolTag == 0 && isSymbolClicked == false {
            var amount = Int(stringNumber(value: lblTotal.text!))!
            if amount > 0 {
                totalAmount = amount
            }
        }
        if totalAmount == 0 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Та мөнгөн дүнгээ оруулна уу!")
            return
        }
        else if totalAmount < 0 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Мөнгөн дүн тэгээс их байх ёстой!")
            return
        }
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let sale = mainStoryBoard.instantiateViewController(withIdentifier: "SalePrintVC") as! SalePrintVC
        sale.totalAmount = numberFormat2(number: totalAmount)
        self.navigationController?.pushViewController(sale, animated: true)
    }
    
    @IBAction func btnCalc_click(_ sender: UIButton) {
        if sender.tag == 14{ //clear
            totalAmount = 0
            value = 0
            currentSymbolTag = 0
            isSymbolClicked = false
            lblTotal.text = "0"
            lblText.text = ""
        }
        else if sender.tag == 13 { //butsah
            var screenNumber = Int(stringNumber(value: lblTotal.text!))!
            screenNumber = screenNumber / 10
            if currentSymbolTag == 0{
                totalAmount = totalAmount / 10
            }
            lblTotal.text = numberFormat2(number: screenNumber)
        }
        else if sender.tag == 15 { //tentsuu
            if isSymbolClicked == false {
                let screenNumber = Int(stringNumber(value: lblTotal.text!))!
                if currentSymbolTag != 0 && screenNumber >= 0{
                    if currentSymbolTag == 12 {
                        totalAmount = totalAmount * screenNumber
                    }
                    else if currentSymbolTag == 11{
                        totalAmount = totalAmount - screenNumber
                    }
                    else{
                        totalAmount = totalAmount + screenNumber
                    }
                    value = totalAmount
                    currentSymbolTag = 0
                    lblTotal.text = numberFormat2(number: totalAmount)
                    lblText.text = ""
                }
            }
        }
        else if sender.tag > -1 && sender.tag < 10 { // too
            if isSymbolClicked == true {
                lblTotal.text = "0"
            }
            isSymbolClicked = false
            let value1 = Int(stringNumber(value: lblTotal.text! + "\(sender.tag)"))!
            if value1 > 50000000 {
                return
            }
            lblTotal.text = numberFormat2(number: value1)
        }
        else{ //uildel
            if currentSymbolTag == 0 {
                value = Int(stringNumber(value: lblTotal.text!))!
                totalAmount = value
                lblText.text = lblTotal.text!
                lblTotal.text = "0"
            }
            else{
                if isSymbolClicked == false{
                    lblText.text = lblText.text! + lblTotal.text!
                    if lblText.text!.count > 0 {
                        value = Int(stringNumber(value: lblTotal.text!))!
                        print(value)
                        if currentSymbolTag == 12 {
                            totalAmount = totalAmount * value
                        }
                        else if currentSymbolTag == 11{
                            totalAmount = totalAmount - value
                        }
                        else{
                            totalAmount = totalAmount + value
                        }
                        
                        print(totalAmount)
                        lblTotal.text = numberFormat2(number: totalAmount)
                    }
                }
                else{
                    let lenght = lblText.text!.count - 3
                    lblText.text = lblText.text!.substring(to: lenght)
                }
            }
            var currentSymbol = ""
            if sender.tag == 12 {
               currentSymbol = "*"
            }
            else if sender.tag  == 11{
               currentSymbol = "-"
            }
            else{
                currentSymbol = "+"
            }
            lblText.text = lblText.text! + " " + currentSymbol + " "
            currentSymbolTag = sender.tag
            isSymbolClicked = true
        }
    }
    
    func getDuration(){
        leftDate = 0
        networkingClient.executeGet(_suburl: API_LICENSE_DURATION, parameters: [:]) { (json, error) in
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    leftDate = json["value"].int!
                    self.addSlideMenuButton(true)
                }
            }
        }
    }
    
    func checkMyVersion() {
        var version = Bundle.main.releaseVersionNumber! + "." + Bundle.main.buildVersionNumber!
        print(version)
        print(versionNum)
        if version != versionNum {
            let refreshAlert = UIAlertController(title: "Мэдээлэл", message: updateInfo, preferredStyle: UIAlertController.Style.alert)
             refreshAlert.addAction(UIAlertAction(title: "Үгүй", style: .default, handler: { (action: UIAlertAction!) in
                 self.dismiss(animated: true, completion: nil)
             }))
            refreshAlert.addAction(UIAlertAction(title: "Тийм", style: .default, handler: { (action: UIAlertAction!) in
                UIApplication.shared.openURL(NSURL(string: "https://apps.apple.com/sg/app/onis-pos/id1232097366")! as URL)
            }))
           
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


