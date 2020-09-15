//
//  NavigationBarViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        let flipToBack = UISwipeGestureRecognizer(target: self, action: #selector(flipAction))
        self.view.addGestureRecognizer(flipToBack)
    }
    
    @objc func flipAction(){
        if(self.topViewController?.navigationItem.rightBarButtonItem?.title == "Edit"){
            performSegue(withIdentifier: "flipToBack", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnFromBackView(segue: UIStoryboardSegue){
    }
}

