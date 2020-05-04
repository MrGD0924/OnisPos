//
//  MenuVC.swift
//  OnisPos
//
//  Created by MG on 4/8/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index: Int32)
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let menuList = ["БОРЛУУЛАЛТ", "БУЦААЛТ", "ТАЙЛАН", "ТОХИРГОО", "ЛИЦЕНЗ СУНГАХ", "ПРОГРАМЫН ТУХАЙ", "ГАРАХ"]
    let menuImages = [  UIImage(named: "menu1"),
                        UIImage(named: "menu2"),
                        UIImage(named: "menu3"),
                        UIImage(named: "menu4"),
                        UIImage(named: "menu5"),
                        UIImage(named: "menu6"),
                        UIImage(named: "menu7")]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblStorename: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblBanner: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor.clear
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
        
        lblStorename.text = storeName
        lblUsername.text = userName
        lblBanner.text = licenceText
        
        if !bannerImage.isEmpty {
            let dataDecoded:NSData = NSData(base64Encoded: bannerImage, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            if lblBanner.text == "Success" {
                self.imgBanner.image = decodedimage
                lblBanner.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell") as! MenuTVCell
        cell.imgMain.image = self.menuImages[indexPath.row]
        cell.lblText.text = self.menuList[indexPath.row]
        cell.backgroundColor = myPeachColor
        let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMenuItem = indexPath.row
         switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "segueSale", sender: self)
                break
            case 1:
                self.performSegue(withIdentifier: "segueReturn", sender: self)
                break
            case 2:
                self.performSegue(withIdentifier: "segueReport", sender: self)
                break
            case 3:
                self.performSegue(withIdentifier: "segueSettings", sender: self)
                break
            case 4:
                self.performSegue(withIdentifier: "segueLicence", sender: self)
                break
            case 5:
                self.performSegue(withIdentifier: "segueAbout", sender: self)
                break
            case 6:
                logout()
                break
            default:
                self.performSegue(withIdentifier: "segueSale", sender: self)
                break
        }
    }

    @IBAction func btnMenu_click(_ sender: UIButton) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnClose){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func logout() {
        let alertController = UIAlertController(title: "Анхаар", message: "Та системээс гарах уу?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Үгүй", style: .destructive, handler: nil)
        
        let yesAction = UIAlertAction(title: "Тийм", style: .default, handler: { (action) in
            SVProgressHUD.show()
            networkingClient.executePut(_suburl: API_LOGOUT, parameters: [:]) { (json, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    showAlertAction(view: self, title: "Анхаар", message: checkMessage(msg: error.localizedDescription))
                    return
                }
                self.performSegue(withIdentifier: "segueLogin", sender: self)
            }
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }
}
