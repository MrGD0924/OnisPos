//
//  LicenceVC.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class LicenceVC: BaseViewController {

    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtTotal: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лиценз сунгах"
        hideKeyboardWhenTappedAround()
        addSlideMenuButton(false)
        setBorderText(txtType)
        setBorderText(txtUnit)
        setBorderText(txtDuration)
        setBorderText(txtTotal)
        
        setFirst()
    }
    
    @IBAction func btnType(_ sender: UIButton) {
        let vc = PayTypeVC(nibName: "PayTypeVC", bundle: nil)
        vc.returnValue = {(value) in
            self.txtType.text = value
            if value == "Өдрөөр" {
                self.txtUnit.text = "200"
            }
            else if value == "Сараар" {
                self.txtUnit.text = "5,000"
            }
            else {
                self.txtUnit.text = "50,000"
            }
            self.Calculate()
        }
        let form = mzFormFactory(viewController: vc, size: CGSize(width: 250, height: 150))
        self.present(form, animated: true, completion: nil)
    }
    
    @IBAction func txtDuration_changed(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 4)
        Calculate()
    }
    
    func setFirst(){
        txtType.text = "Сараар"
        txtUnit.text = numberFormat2(number: 5000)
    }
    
    func  Calculate(){
        var value1 = Int(stringNumber(value: txtUnit.text!))!
        var value2 = 0
        if txtDuration.text!.count != 0 {
            value2 = Int(stringNumber(value: txtDuration.text!))!
        }
        txtTotal.text = numberFormat2(number: value1 * value2)
    }
    
    @IBAction func btnUnit(_ sender: UIButton) {
        var type = 0
        if txtType.text! == "Өдрөөр" {
            type = 2
        }
        else if txtType.text! == "Сараар" {
            type = 1
        }
        
        if txtTotal.text! == "0" || txtTotal.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Сунгах хугацаагаа оруулна уу!")
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LicenceVerifyVC") as? LicenceVerifyVC
        vc?.isUnit = true
        vc?.textTotal = txtTotal.text!
        vc?.type = type
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func btnAcc(_ sender: UIButton) {
        if txtTotal.text! == "0" || txtTotal.text!.isEmpty {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Сунгах хугацаагаа оруулна уу!")
            return
        }
        
        if Int(stringNumber(value: txtTotal.text!))! >= 1000000 {
            showAlertAction(view: self, title: "Мэдээлэл", message: "Лиценз сунгах дүн 1,000,000-с их байж болохгүй!")
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LicenceVerifyVC") as? LicenceVerifyVC
        vc?.textTotal = txtTotal.text!
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
