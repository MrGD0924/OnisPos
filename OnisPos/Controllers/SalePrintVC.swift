//
//  SalePrintVC.swift
//  OnisPos
//
//  Created by MG on 4/21/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Printer

class SalePrintVC: BaseViewController {

    @IBOutlet weak var txtTotal: UITextField!
    @IBOutlet weak var txtPayed: UITextField!
    @IBOutlet weak var txtChange: UITextField!
    var totalAmount = ""
    var isClear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(true)

        setBorderText(txtTotal)
        setBorderText(txtPayed)
        setBorderText(txtChange)
        
        txtChange.text = "0"
        txtPayed.text = totalAmount
        txtTotal.text = totalAmount
    }
    
    @IBAction func btnPersonal(_ sender: UIButton) {
        let value = Int(stringNumber(value: txtChange.text!))!
        if value < 0 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Төлбөр дутуу байна!")
            return
        }
        
        let vc = SalePopupVC(nibName: "SalePopupVC", bundle: nil)
        vc.type = 1
        vc.saleAmount = Int(stringNumber(value: txtTotal.text!))!
        vc.returnOK = {
            self.performSegue(withIdentifier: "segueBack", sender: self)
        }
        vc.connectPrint = {
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BluetoothPrinterSelectTableViewController") as? BluetoothPrinterSelectTableViewController
                vc!.sectionTitle = "Bluetooth Printer-ээ сонгоно уу"
                vc!.printerManager = bluetoothPrinterManager
                self.present(vc!, animated: true, completion: nil)
             }
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 239))
        self.present(form, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCompany(_ sender: UIButton) {
        let value = Int(stringNumber(value: txtChange.text!))!
        if value < 0 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Төлбөр дутуу байна!")
            return
        }
        
        let vc = SalePopupVC(nibName: "SalePopupVC", bundle: nil)
        vc.type = 3
        vc.saleAmount = Int(stringNumber(value: txtTotal.text!))!
        vc.returnOK = {
            self.performSegue(withIdentifier: "segueBack", sender: self)
        }
        vc.connectPrint = {
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "BluetoothPrinterSelectTableViewController") as? BluetoothPrinterSelectTableViewController
               vc!.sectionTitle = "Bluetooth Printer-ээ сонгоно уу"
               vc!.printerManager = bluetoothPrinterManager
               self.present(vc!, animated: true, completion: nil)
            }
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 350, height: 329))
        self.present(form, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClear(_ sender: Any) {
        if txtPayed.text!.count == 1 {
            txtPayed.text = "0"
        }
        else{
            var number = Int(stringNumber(value: txtPayed.text!))!
            number = number / 10
            txtPayed.text = numberFormat2(number: number)
        }
        isClear = false
        Calculate()
    }
    
    @IBAction func btnCalc(_ sender: UIButton) {
        if isClear {
            txtPayed.text = ""
            let numberTotal = Int(stringNumber(value: txtPayed.text! + "\(sender.tag)"))
            txtPayed.text! = numberFormat2(number: numberTotal!)
        }
        else{
            let numberTotal = Int(stringNumber(value: txtPayed.text! + "\(sender.tag)"))
            txtPayed.text! = numberFormat2(number: numberTotal!)
        }
        isClear = false
        Calculate()
    }
    
    func Calculate() {
        let number1 = Int(stringNumber(value: txtPayed.text!))!
        let number2 = Int(stringNumber(value: txtTotal.text!))!
        let numberTotal = number1 - number2
        
        txtChange.text = numberFormat2(number: numberTotal)
    }
}
