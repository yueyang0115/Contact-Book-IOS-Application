//
//  BackViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flipToFront = UISwipeGestureRecognizer(target: self, action: #selector(flipAction(flip:)))
        flipToFront.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(flipToFront)
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
