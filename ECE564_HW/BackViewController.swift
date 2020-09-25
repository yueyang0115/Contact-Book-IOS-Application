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
        setStarView()
        setBackgroundImageView()
        setPeopleImageView()
        
    }
    
    func setStarView(){
        // create a new UIView and add it to the view controller
        let starView = Star()
        starView.frame = CGRect(x: 50, y: 100, width:100, height: 100)
        starView.backgroundColor = UIColor.clear
        shrinkView(myView: starView)
        
        let star1 = Star()
        star1.frame = CGRect(x: 120, y: 120, width:100, height: 100)
        star1.backgroundColor = UIColor.clear
        shrinkView(myView: star1)
        
        let star2 = Star()
        star2.frame = CGRect(x: 210, y: 130, width:100, height: 100)
        star2.backgroundColor = UIColor.clear
        shrinkView(myView: star2)
        
        let star3 = Star()
        star3.frame = CGRect(x: 90, y: 170, width:100, height: 100)
        star3.backgroundColor = UIColor.clear
        shrinkView(myView: star3)
        
        let star4 = Star()
        star4.frame = CGRect(x: 200, y: 180, width:100, height: 100)
        star4.backgroundColor = UIColor.clear
        shrinkView(myView: star4)
        
        let star5 = Star()
        star5.frame = CGRect(x: 270, y: 220, width:100, height: 100)
        star5.backgroundColor = UIColor.clear
        shrinkView(myView: star5)
        
        let star6 = Star()
        star6.frame = CGRect(x: 350, y: 100, width:100, height: 100)
        star6.backgroundColor = UIColor.clear
        shrinkView(myView: star6)
        
        let star7 = Star()
        star7.frame = CGRect(x: 140, y: 190, width:100, height: 100)
        star7.backgroundColor = UIColor.clear
        shrinkView(myView: star7)
        
        let star8 = Star()
        star8.frame = CGRect(x: 240, y: 230, width:100, height: 100)
        star8.backgroundColor = UIColor.clear
        shrinkView(myView: star8)
    }
    
    func shrinkView(myView: UIView){
        let originalCenter = myView.center
        let animatorShrink = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) { [myView] in
            myView.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 0.9, y: 0.9)
        }

        let animatorEnlarge = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) { [myView] in
                   myView.center = originalCenter
                   myView.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 1, y: 1)
               }

        view?.addSubview(myView)

        animatorShrink.startAnimation()
        animatorShrink.addCompletion { _ in
            animatorShrink.stopAnimation(true)
            animatorEnlarge.startAnimation()
        }
//
        animatorEnlarge.addCompletion { _ in
            animatorEnlarge.stopAnimation(true)
            animatorShrink.startAnimation()
            //myView.removeFromSuperview()
            //self.setStarView()
            self.shrinkView(myView: myView)
        }
    }
    
    func enlargeView(myView: UIView){
        let option: UIView.AnimationOptions = [.repeat]
        UIView.animate(withDuration: 1, delay: 0, options: option, animations: {
            self.shrinkView(myView: myView)
//            myView.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 0.9, y: 0.9)
//            myView.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 1, y: 1)
        }, completion: nil)
        //view?.addSubview(myView)
    }
    
    func setPeopleImageView(){
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
    
    func setBackgroundImageView(){
        let cafeteriaView = UIImageView()
        cafeteriaView.frame = CGRect(x: -300, y: 300, width: 300, height: 200)
        cafeteriaView.image = UIImage(named: "cafeteria")
        moveImage(imageView: cafeteriaView)
        view?.addSubview(cafeteriaView)
        
        let cafeHouseView = UIImageView()
        cafeHouseView.frame = CGRect(x: -900, y: 340, width: 300, height: 200)
        cafeHouseView.image = UIImage(named: "cafeteria2")
        moveImage(imageView: cafeHouseView)
        view?.addSubview(cafeHouseView)
        
        let houseView = UIImageView()
        houseView.frame = CGRect(x: -1500, y: 350, width: 300, height: 200)
        houseView.image = UIImage(named: "car")
        moveImage(imageView: houseView)
        view?.addSubview(houseView)
    }
    
    func moveImage(imageView: UIImageView){
        let option: UIView.AnimationOptions = [.repeat]
        UIView.animate(withDuration: 6, delay: 2, options: option, animations: {
            imageView.transform = CGAffineTransform(translationX:
                self.view.bounds.width + 5*imageView.frame.width, y: 0)
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
