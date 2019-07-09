//
//  ViewController.swift
//  AnimationDemo
//
//  Created by trinh.hoang.hai on 7/4/19.
//  Copyright © 2019 FT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!


    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var UsernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Completed"]
    let transition = PopAnimator()

    var statusPosition = CGPoint.zero

    // MARK: view controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)

        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)

        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)

        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)

        statusPosition = status.center
    }

    override func viewWillAppear(_ animated: Bool) {

        // MARK: Setup for animations

        headerLabel.center.x -= view.bounds.width
        UsernameTF.center.x -= view.bounds.width
        passwordTF.center.x -= view.bounds.width

        image1.alpha = 0.4
//        image1.center.x += view.bounds.width*2/3
        image2.alpha = 0.2
//        image2.center.x += view.bounds.width*1/5
        image3.alpha = 0.6
//        image3.center.x += view.bounds.width*4/5
        image4.alpha = 0.3
//        image4.center.x += view.bounds.width*1/3

        loginButton.center.y += 30.0
        loginButton.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.headerLabel.center.x += self.view.bounds.width
        }

        UIView.animate(withDuration: 0.5, delay: 0.3 ,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.UsernameTF.center.x += self.view.bounds.width
            }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.4 ,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.passwordTF.center.x += self.view.bounds.width
        }, completion: nil)

        // MARK: Clouds animation

        UIView.animate(withDuration: 1.5, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.image1.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 1.5, delay: 0.9, options: [.repeat, .autoreverse], animations: {
            self.image2.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 1.5, delay: 1.6, options: [.repeat, .autoreverse], animations: {
            self.image3.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 1.5, delay: 2.3, options: [.repeat, .autoreverse], animations: {
            self.image4.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y -= 30.0
            self.loginButton.alpha = 1.0
        }, completion: nil)

        animateCloud(image1)
        animateCloud(image2)
        animateCloud(image3)
        animateCloud(image4)
    }

    @IBAction func login() {
        view.endEditing(true)

        loginButton.isEnabled = false

        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
                self.loginButton.bounds.size.width += 80.0
        }, completion: {_ in
            self.showMessage(index: 0)
        })

        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping:
            0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.loginButton.center.y += 60.0
                self.loginButton.backgroundColor =
                    UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)

                self.spinner.center = CGPoint(
                    x: 40.0,
                    y: self.loginButton.frame.size.height/2
                )
                self.spinner.alpha = 1.0
                
        }, completion: nil)


    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === UsernameTF) ? passwordTF : UsernameTF
        nextField?.becomeFirstResponder()
        return true
    }

    func showMessage(index: Int) {
        label.text = messages[index]
        UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionCurlDown], animations: {
                self.status.isHidden = false
        }, completion: {_ in
            delay(2.0) {
                if index < self.messages.count-1 {
                    self.removeMessage(index: index)
                } else {
                    self.resetForm()
                    guard let flightVc = self.storyboard?.instantiateViewController(withIdentifier: "FlightViewController") as? FlightViewController else { return }
                    self.present(flightVc, animated: true, completion: nil)
                    flightVc.transitioningDelegate = self
                    self.transitioningDelegate = self
                } }
        })
    }

    func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
            self.status.center.x += self.view.frame.size.width
        }, completion: {_ in
            self.status.isHidden = true
            self.status.center = self.statusPosition
            self.showMessage(index: index+1)
        })
    }

    func resetForm() {

        UIView.transition(with: status, duration: 0.2, options: [.curveEaseIn, .transitionCurlUp],  animations: {
            self.status.isHidden = true
            self.status.center = self.statusPosition
            }, completion: nil )

        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.spinner.center = CGPoint(x: -20.0, y: 16.0)
            self.spinner.alpha = 0.0
            self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.loginButton.bounds.size.width -= 80.0
            self.loginButton.center.y -= 60.0
        }, completion: nil)

        loginButton.isEnabled = true
    }

    func animateCloud(_ cloud: UIImageView) {
        let cloudSpeed = 60.0/view.frame.size.width
        let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
            cloud.frame.origin.x = self.view.frame.size.width
        }, completion: {_ in
            cloud.frame.origin.x = -cloud.frame.size.width
            self.animateCloud(cloud)
        })
    }
    
}

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

extension ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            return transition
    }
}
