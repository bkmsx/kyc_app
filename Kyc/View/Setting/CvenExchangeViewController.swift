//
//  CvenExchangeViewController.swift
//  Kyc
//
//  Created by Lai Trung Tien on 10/30/18.
//  Copyright © 2018 Lai Trung Tien. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CvenExchangeViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.init(argb: Colors.darkestGray)
        settings.style.buttonBarItemBackgroundColor = UIColor.init(argb: Colors.darkestGray)
        
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = UIColor.init(argb: Colors.lightBlue)
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 13)
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let buyVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.BuyViewController)
        let sellVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SellViewController)
        return [buyVC!, sellVC!]
    }

    //MARK: - Navigations
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
