//
//  PayTypeVC.swift
//  OnisPos
//
//  Created by MG on 4/23/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class PayTypeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableMain: UITableView!
    var listMain = ["Жилээр", "Сараар", "Өдрөөр"]
    var returnValue: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableMain.dataSource = self
        tableMain.delegate = self
        
        let nibName = UINib(nibName: "PayTypeCell", bundle: nil)
        tableMain.register(nibName, forCellReuseIdentifier: "PayTypeCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayTypeCell") as! PayTypeCell
        cell.lblText.text = self.listMain[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        returnValue!(listMain[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
