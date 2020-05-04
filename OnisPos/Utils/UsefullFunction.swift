//
//  UsefullFunction.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//
import UIKit
import MZFormSheetPresentationController
import Printer

var selectedMenuItem = 0
var userName = ""
var storeName = ""
var storeInformation:StoreInfo? = nil
var newStoreInfo:StoreInfo? = nil
var listDistrict:[District] = []
var listClass:[Classs] = []
var leftDate = 0
var isLicensed = false
var licenceText = ""
var versionNum = ""
var updateInfo = ""
var bannerImage = ""

public let bluetoothPrinterManager = BluetoothPrinterManager()
public let dummyPrinter = DummyPrinter()

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

func setBorderText(_ text: UITextField) {
    text.layer.borderColor = myOrangeColor.cgColor
    text.layer.borderWidth = 1.0
}

func setBorderText2(_ text: UITextView) {
    text.layer.borderColor = myOrangeColor.cgColor
    text.layer.borderWidth = 1.0
}

func addLeftImageTo(txtField: UITextField, andImage img: UIImage){
    let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 25, height: 25))
    imageView.image = img
    let iconContainerView: UIView = UIView(frame: CGRect(x: 20,y: 0,width: 35,height: 35))
    iconContainerView.addSubview(imageView)
    txtField.leftView = iconContainerView
    txtField.leftViewMode = .always
}

func checkMessage(msg: String) -> String{
    print(msg)
    if(msg.contains("The Internet connection appears to be offline")){
        return "Интернет холболтоо шалгана уу!"
    }
    
    if(msg.contains("timed out")){
        return "Интернетээ шалгаад дахин оролдоно уу!"
    }
    return msg
}

func showAlertAction(view: UIViewController, title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
        print("Action")
    }))
    view.present(alert, animated: true, completion: nil)
}

func mzFormFactory(viewController: UIViewController, size: CGSize) -> MZFormSheetPresentationViewController{
    let formSheet = MZFormSheetPresentationViewController(contentViewController: viewController)
    
    formSheet.presentationController?.shouldDismissOnBackgroundViewTap = true
    //formSheet.presentationController!.shouldCenterVertically = true
    formSheet.presentationController?.contentViewSize = size
    return formSheet
}

func numberFormat(number: Double) -> String{
    return NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
}

func numberFormat2(number: Int) -> String{
    return NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
}

func stringNumber(value: String) -> String{
    return value.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
}

func getCurrentDate()->String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // change format as per needs
    return formatter.string(from: date)
}

func ReloadDistrict() {
    if listDistrict.count == 0 {
        networkingClient.executeGet(_suburl: API_GET_DISTRICT, parameters: [:]) { (json, error) in
            if let error = error {
                //showAlertAction(view: view, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"].array
                    data?.forEach({ (row) in
                        let item = District(row["distcode"].stringValue, row["distname"].stringValue)
                        listDistrict.append(item)
                    })
                }
            }
        }
    }
}

func ReloadCategory() {
    if listClass.count == 0 {
        networkingClient.executeGet(_suburl: API_GET_CLASS, parameters: [:]) { (json, error) in
            if let error = error {
                //showAlertAction(view: view, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    let data = json["value"].array
                    data?.forEach({ (row) in
                        let item = Classs(row["classcode"].stringValue, row["classname"].stringValue)
                        listClass.append(item)
                    })
                }
            }
        }
    }
}

func checkMaxLength(textField: UITextField!, maxLength: Int) {
    if (textField.text!.count > maxLength) {
        textField.deleteBackward()
    }
}

func stringToDateTime(value: String) -> String{
    let returnData = value.substring(to: 10) + " " + value.substring(with:11..<19)
    return returnData
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidPhone(_ phone: String) -> Bool {
   let PHONE_REGEX = "^\\d{8}"
   let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
   let result = phoneTest.evaluate(with: phone)
   return result
}
