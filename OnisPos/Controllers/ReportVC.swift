//
//  ReportVC.swift
//  OnisPos
//
//  Created by MG on 4/13/20.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import CarbonKit

class ReportVC: BaseViewController, CarbonTabSwipeNavigationDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Тайлан"
        addSlideMenuButton(false)
        
        let items = ["Өдрөөр", "Сараар", "Жилээр"]
        let segmentControlWidth = UIScreen.main.bounds.size.width / CGFloat(items.count)
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        
        for (index, element) in items.enumerated() {
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(segmentControlWidth, forSegmentAt: index)
        }
        carbonTabSwipeNavigation.setNormalColor(myBlackColor)
        carbonTabSwipeNavigation.setSelectedColor(myOrangeColor)
        carbonTabSwipeNavigation.setIndicatorColor(myOrangeColor)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if(index == 0){
            return self.storyboard?.instantiateViewController(withIdentifier: "ReportDayVC") as! ReportDayVC
        }
        else if(index == 1){
            return self.storyboard?.instantiateViewController(withIdentifier: "ReportMonthVC") as! ReportMonthVC
        }
        else{
            return self.storyboard?.instantiateViewController(withIdentifier: "ReportYearVC") as! ReportYearVC
        }
    }
    
}
