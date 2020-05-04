//
//  PopupVC.swift
//  OnisPos
//
//  Created by MG on 4/20/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class PopupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableMain: UITableView!
    var type = 0
    var filteredDistrict = listDistrict
    var filteredClass = listClass
    
    var returnDistrict: ((District)->())?
    var returnCategory: ((Classs)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imgSearch = UIImage(named:"search")
        addLeftImageTo(txtField: txtSearch, andImage: imgSearch!)
        
        tableMain.delegate = self
        tableMain.dataSource = self
        
        let nibName = UINib(nibName: "PopupCell", bundle: nil)
        tableMain.register(nibName, forCellReuseIdentifier: "PopupCell")
    }
    
    @IBAction func txtSearch_changed(_ sender: UITextField) {
        if(type == 1){
            if(txtSearch.text!.isEmpty){
                self.filteredDistrict = listDistrict
            }
            else{
                self.filteredDistrict = listDistrict
                let list = filteredDistrict.filter { $0.distname!.lowercased().contains( String(txtSearch!.text!).lowercased() ) }
                self.filteredDistrict = list
            }
        }
        else{
            if(txtSearch.text!.isEmpty){
                self.filteredClass = listClass
            }
            else{
                self.filteredClass = listClass
                let list = filteredClass.filter { $0.classname!.lowercased().contains( String(txtSearch!.text!).lowercased() ) }
                self.filteredClass = list
            }
        }
        
        self.tableMain.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1 {
            return filteredDistrict.count
        }
        else {
            return filteredClass.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupCell") as! PopupCell
        if(type == 1){
            cell.lblText.text = filteredDistrict[indexPath.row].distname
        }
        else{
            cell.lblText.text = filteredClass[indexPath.row].classname
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(type == 1){
            returnDistrict?(filteredDistrict[indexPath.row])
        }
        else{
            returnCategory?(filteredClass[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
}
