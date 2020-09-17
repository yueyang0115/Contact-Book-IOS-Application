//
//  NavigationBarViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class NavigationBarViewController: UINavigationController {

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
    

    
    // MARK: - Navigation

    // preparation before navigation, pass choosen person to BackViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "flipToBack"){
            let middleScene = self.topViewController as! InformationViewController
            let dst = segue.destination as! BackViewController
            dst.person = middleScene.edittedPerson
        }
    }
    
    @IBAction func returnFromBackView(segue: UIStoryboardSegue){
    }
}

