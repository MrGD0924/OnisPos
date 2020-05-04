//
//  SalePopupVC.swift
//  OnisPos
//
//  Created by MG on 4/21/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Printer
import CoreBluetooth

class SalePopupVC: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{

    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt1Height: NSLayoutConstraint!
    @IBOutlet weak var txt2Height: NSLayoutConstraint!
    var returnOK: (()->())?
    var connectPrint: (()->())?
    
    var type = 0 //type = 1 huwi, 3 baiguullaga
    var manager:CBCentralManager!
    let mount = 0
    var saleAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        setBorderText(txt1)
        setBorderText(txt2)
        setBorderText(txt3)
        setBorderText(txt4)
        
        if type == 1 {
            txt1Height.constant = 0
            txt2Height.constant = 0
            
            txt3.placeholder = "И мэйл хаяг"
            txt4.placeholder = "Утасны дугаар"
        }
        else{
            txt1.placeholder = "Татвар төлөгчийн код"
            txt2.placeholder = "Татвар төлөгчийн нэр"
            txt3.placeholder = "И мэйл хаяг"
            txt4.placeholder = "Утасны дугаар"
            
            let imgUser = UIImage(named:"user")
            
            addLeftImageTo(txtField: txt1, andImage: imgUser!)
            addLeftImageTo(txtField: txt2, andImage: imgUser!)
        }
        
        let imgPass = UIImage(named:"password")
        let imgPhone = UIImage(named:"phone")
        
        addLeftImageTo(txtField: txt3, andImage: imgPass!)
        addLeftImageTo(txtField: txt4, andImage: imgPhone!)
        
        placeHolderColor(txt1)
        placeHolderColor(txt2)
        placeHolderColor(txt3)
        placeHolderColor(txt4)
    }
    
    func placeHolderColor(_ textField: UITextField) {
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
    }
    
    @IBAction func txt1_changed(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 10)
        txt1.text = txt1.text!.uppercased()
    }
    
    @IBAction func txt1_focus(_ sender: UITextField) {
        checkRegnum()
    }
    
    @IBAction func txt3_changed(_ sender: UITextField) {
        if sender.text!.count > 0 {
            txt4.text = ""
        }
        checkMaxLength(textField: sender, maxLength: 30)
    }
    
    @IBAction func txt4_changed(_ sender: UITextField) {
        if sender.text!.count > 0 {
            txt3.text = ""
        }
        checkMaxLength(textField: sender, maxLength: 8)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        if txt3.text!.isEmpty && txt4.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "И-мэйл хаяг болон утасны дугаар оруулна уу!")
            return
        }
        else{
            if txt3.text!.isEmpty{
                if !isValidPhone(txt4.text!) {
                    showAlertAction(view: self, title: "Мэдээлэл", message: "Таны оруулсан утасны дугаар буруу байна!")
                    return
                }
            }
            else{
                if !isValidEmail(txt3.text!) {
                    showAlertAction(view: self, title: "Мэдээлэл", message: "Таны оруулсан и-мэйл хаяг буруу байна!")
                    return
                }
            }
        }
        
        if type == 3 && txt2.text!.isEmpty{
            showAlertAction(view: self, title: "Мэдээлэл", message: "Байгууллагын регистрийн дугаарaa оруулна уу!")
            return
        }
        Send(false)
    }
    
    @IBAction func btnPrint(_ sender: UIButton) {
        if type == 3 {
            if txt2.text!.isEmpty{
                showAlertAction(view: self, title: "Мэдээлэл", message: "Байгууллагын регистрийн дугаарaa оруулна уу!")
                return
            }
            else{
                if txt1.text!.isEmpty {
                    showAlertAction(view: self, title: "Мэдээлэл", message: "Байгууллагын регистрийн дугаарaa оруулна уу!")
                    return
                }
            }
        }
        
        manager = CBCentralManager(delegate: self, queue: nil, options: nil)
        manager.delegate = self
        
        
        if bluetoothPrinterManager.canPrint {
            Send(true)
        }
        else {
            connectPrint!()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func checkRegnum() {
        self.txt2.text = ""
        if(txt1.text!.count > 0){
            SVProgressHUD.show()
            var register = String(utf8String: txt1.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            networkingClient.executePut(_suburl: API_CHECK_REGISTER_COMPANY + register!, parameters: [:]) { (json, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
                }
                else if let json = json {
                    let isSuccess = json["success"]
                    let message = String(json["message"].string!)
                    if(isSuccess == true){
                        self.txt2.text = String(json["value"].string!)
                    }
                    else{
                        if(self.txt1.text! == "0000038" || self.txt1.text! == "0000039"){
                            self.txt2.text = "Test"
                            return
                        }
                        showAlertAction(view: self, title: "Алдаа", message: message)
                    }
                }
            }
        }
    }
    
    func Send(_ isPrint: Bool){
        
        SVProgressHUD.show(withStatus: "Түр хүлээнэ үү.")
        
        let storeId = UserDefaults.standard.integer(forKey: "storeId")
        let userId = UserDefaults.standard.integer(forKey: "userID")
        let imei = UIDevice.current.identifierForVendor!.uuidString
        let date = stringFromDate(Date())
        
        let parameters: Parameters = [
            "slsdate": date,
            "storeid": storeId,
            "userid": userId,
            "amount": saleAmount,
            "billtype": type,
            "taxpayernum": txt1.text!,
            "custcode": type == 3 ? txt1.text : "",
            "custemail": isPrint ? "" : txt3.text!,
            "custphone": isPrint ? "" : txt4.text!,
            "imecode": imei,
            "taxpayername": txt2.text!
        ]

        networkingClient.executePost(_suburl: API_SALES, parameters: parameters) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
            }
            else if let json = json {
                let isSuccess = json["success"]
                if(isSuccess == true){
                    if isPrint {
                        let data = json["value"]
                        self.printBill(data: data)
                    }
                    
                    self.okAction(title: "Амжилттай", message: "Гүйлгээ амжилттай хийгдлээ.")
                }
                else{
                    let message = String(json["message"].string!)
                    showAlertAction(view: self, title: "Алдаа", message: message)
                }
            }
        }
    }
    
    func printBill(data: JSON){
        let regnum = data["regnum"].string!
        let slsnum = data["slsnum"].string!
        let billdate = stringToDateTime(value: data["billdate"].string!)
        let billid = data["billid"].stringValue
        let qrdata = data["qrdata"].stringValue
        let lottery = data["lottery"].stringValue
        let billAmount = numberFormat2(number: data["amount"].int!)
        let vat = numberFormat(number: round(data["vat"].double! * 100)/100 )
        let taxpayernum = data["taxpayernum"].stringValue
        let taxpayername = data["taxpayername"].stringValue
        
        var name = storeName
        name = name.replacingOccurrences(of: "Ү", with: "V", options: .literal, range: nil)
        name = name.replacingOccurrences(of: "ү", with: "v", options: .literal, range: nil)
        name = name.replacingOccurrences(of: "Ө", with: "Q", options: .literal, range: nil)
        name = name.replacingOccurrences(of: "ө", with: "e", options: .literal, range: nil)

        var ticket = Ticket(.text(.init(content: name, predefined: .bold, .alignment(.center))))
        ticket.add(block: .blank)
        ticket.add(block: .plainText("ТТД    :  " + regnum))
        ticket.add(block: .plainText("Баримт :  " + slsnum))
        ticket.add(block: .plainText("Огноо  :  " + billdate))
        ticket.add(block: .text(.init(content: "ДДТД: " + billid, predefined: .small)))
        if type != 1 {
            ticket.add(block: .text(.init(content: "Худалдан авагч  : " , predefined: .bold)))
            ticket.add(block: .plainText("ТТД    :  " + taxpayernum))
            ticket.add(block: .plainText("НЭР    :  " + taxpayername))
        }
        ticket.add(block: .blank)
        ticket.add(block: .dividing)
        var row1 = " Барааны vнэ :"
        var row2 = " НQАТ :"
        
        row1 = row1.padding(toLength: 15, withPad: " ", startingAt: 0)
        row2 = row2.padding(toLength: 15, withPad: " ", startingAt: 0)
        
        let row11 = billAmount.leftPadding(toLength: 13, withPad: " ", count: billAmount.count)
        let row22 = vat.leftPadding(toLength: 13, withPad: " ", count: vat.count)

        ticket.add(block: .text(.init(content: row1 + " " + row11, predefined: .alignment(.left))))
        ticket.add(block: .text(.init(content: row2 + " " + row22, predefined: .alignment(.left))))
        ticket.add(block: .dividing)
        ticket.add(block: .blank(2))
        if type == 1 {
            ticket.add(block: Block(Text(content: "Сугалааны дугаар: " + lottery, predefined: .alignment(.center))))
            ticket.add(block: .blank)
        }
        ticket.add(block: .qr(qrdata))
        ticket.add(block: .blank)
        
        ticket.feedLinesOnHead = 2
        ticket.feedLinesOnTail = 1
        
        bluetoothPrinterManager.print(ticket)
        dummyPrinter.print(ticket)
    }
    
    func okAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хаах", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.returnOK!()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = String()
        switch central.state
        {
        case .unsupported:
            message = "Bluetooth дэмжихгүй байна."
        case .unknown:
            message = "Bluetooth төлөв тодорхойгүй байна. Та шалгаад дахин оролдоно уу"
        case .unauthorized:
            message = "Bluetooth is unauthorized"
        case .poweredOff:
            message = "Bluetooth -ээ асааж принтертэй холбогдоно уу."
        default:
            break
        }

        if !message.isEmpty{
            UIAlertView( title: "Bluetooth тохиргоо", message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character, count: Int) -> String {
        let newLength = count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self.substring(from: index(self.startIndex, offsetBy: newLength - toLength))
        }
    }
}
