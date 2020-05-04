//
//  LicenceTextVC.swift
//  OnisPos
//
//  Created by MG on 4/30/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class LicenceTextVC: UIViewController {

    @IBOutlet weak var lblText: UILabel!
    var returnValue: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblText.attributedText =  NSMutableAttributedString()
                .normal("Сайн байна уу? " + userName + "\n")
                .normal("Та лицензийн төлбөрөө төлнө үү!\nТа ")
                .bold("ХААН ")
                .normal("банкны ")
                .bold("5038060153 ")
                .normal("тоот дансанд гүйлгээний утга дээрх ")
                .bold("НЭВТРЭХ ДУГААР")
                .normal("-ыг, хүлээн авагчийн нэр дээр ")
                .bold("Датакейр ")
                .normal("гэж бичин лицензийн төлбөрөө шилжүүлнэ үү. Мөн та ")
                .bold("76060006 ")
                .normal("дугаар луу холбогдож лавлах боломжтой.")
                .orangeColor("\n\nМанай системийг сонгосон хэрэглэгч танд баярлалаа.")
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPayment(_ sender: UIButton) {
        self.returnValue!()
        self.dismiss(animated: true, completion: nil)
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

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 16 }
    var boldFont:UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeColor(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : myOrangeColor
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
