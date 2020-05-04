//
//  MainNavigationController.swift
//  OnisPos
//
//  Created by MG on 4/8/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class MainNavigationController: ENSideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a table view controller
        let menuViewController = MenuVC()
        
        // Create side menu
        sideMenu = ENSideMenu(sourceView: view, menuViewController: menuViewController, menuPosition:.left)
        
        // Set a delegate
        sideMenu?.delegate = self
        
        // Configure side menu
        sideMenu?.menuWidth = 300.0
        
        // Show navigation bar above side menu
        view.bringSubviewToFront(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainNavigationController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}
