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
       let flipToBack = UISwipeGestureRecognizer(target: self, action: #selector(flipAction(flip:)))
       flipToBack.direction = UISwipeGestureRecognizer.Direction.left
       self.view.addGestureRecognizer(flipToBack)
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

extension UIViewController{
    @objc func flipAction(flip : UISwipeGestureRecognizer){
        switch flip.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "flipToFront", sender: self)
        case 2:
            performSegue(withIdentifier: "flipToBack", sender: self)
        default:
            break
        }
    }
}

