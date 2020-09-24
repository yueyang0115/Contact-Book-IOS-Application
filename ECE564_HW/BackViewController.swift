//
//  BackViewController.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {
    var person: DukePerson?
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textViewConfiguration()
        flipConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImageAnimationView()
    }
    
    // MARK: - image-animation
    func setImageAnimationView(){
        //setLampImage()
        setCafeteriaImage()
        //setbgImage()
        setHobbyImage()
    }
    
    func setHobbyImage(){
        let iav = UIImageView()
        iav.frame = CGRect(x: 0, y: 350, width: 400, height: 300)
        
        //let i1 = UIImage(named: "skate1")!
        let i2 = UIImage(named: "skate2")!
        let i3 = UIImage(named: "skate3")!
        let i4 = UIImage(named: "skate4")!
        let i5 = UIImage(named: "skate5")!
        let i6 = UIImage(named: "skate6")!
        iav.animationImages = [i2, i3, i4, i5, i6]
        iav.animationDuration = 1
        iav.startAnimating()
        view?.addSubview(iav)
    }
    
    func setLampImage(){
        let iav = UIImageView()
        iav.frame = CGRect(x: 0, y: 300, width: 100, height: 200)
        iav.image = UIImage(named: "lamp")
        moveImage(imageView: iav)
        view?.addSubview(iav)
    }
    
    func setCafeteriaImage(){
        let iav = UIImageView()
        iav.frame = CGRect(x: 0, y: 300, width: 300, height: 200)
        iav.image = UIImage(named: "cafeteria")
        moveImage(imageView: iav)
        view?.addSubview(iav)
    }
    
    func moveImage(imageView: UIImageView){
        let option: UIView.AnimationOptions = [.repeat]
        UIView.animate(withDuration: 3, delay: 0, options: option, animations: {
            imageView.transform = CGAffineTransform(translationX:
                self.view.bounds.width + imageView.frame.width, y: 0)
        }, completion: nil)
    }
    
    // MARK: - textView-related
    func textViewConfiguration(){
        //textView.removeFromSuperview()  // first remove
        
        let titleFont = UIFont(name: "Cochin-BoldItalic", size: 27.0)
        let paragraphFont = UIFont(name: "Cochin-BoldItalic", size: 24.0) //Palatino-BoldItalic
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
    
        // first line of string, title
        let textLine1 =  "Dear \(person?.firstName ?? "") \(person?.lastName ?? ""),\n"
        let firstAttribute = [
            NSAttributedString.Key.shadow: myShadow,
            NSAttributedString.Key.font: titleFont]
        let firstString = NSMutableAttributedString(string: textLine1, attributes: (firstAttribute) as [NSAttributedString.Key : Any])
        
        // second line of string, content
        let textLine2 = "Thanks for your contibution to Duke University! We are excited to have you as one of the \(person?.role?.lowercased() ?? "Dukie")s at Duke.\n"
        let secondAttribute = [NSAttributedString.Key.font: paragraphFont]
        let secondString = NSMutableAttributedString(string: textLine2, attributes: (secondAttribute) as [NSAttributedString.Key : Any])
        
        // third line of string, content
        let textLine3 = "Best wishes to the entire Duke family in this troubling time."
        let thirdAttributes = [
            NSAttributedString.Key.font: paragraphFont as Any,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue ]
        let thirdString = NSAttributedString(string: textLine3, attributes: thirdAttributes)
        
        let newLine = NSAttributedString(string: "\n")
        firstString.append(newLine)
        firstString.append(newLine)
        firstString.append(secondString)
        firstString.append(newLine)
        firstString.append(thirdString)
                
        textView.frame = CGRect(x: 40, y: 150, width: 300, height: 400)
        textView.backgroundColor = UIColor.clear
        textView.attributedText = firstString
        view.addSubview(textView)
    }
    
    // MARK: - flip-related
    func flipConfiguration(){
        let returnFromBack = UISwipeGestureRecognizer(target: self, action: #selector(flipAction))
        self.view.addGestureRecognizer(returnFromBack)
    }
    
    @objc func flipAction(){
        performSegue(withIdentifier: "returnFromBack", sender: self)
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
