//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var bg: UIView!
    var signupButton: UIButton!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var restofView: UIView!
    
    var yToGoTo: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupBg()
        setupScrollView()
        setupSignUpButton()
        setUpTextFields()
    }
    
    func setupBg() {
        bg = UIView(frame: view.frame)
        //rgb(84, 160, 255)
        bg.backgroundColor = UIColor(red: 84/255, green: 160/255, blue: 255/255, alpha: 1.0)
        view.addSubview(bg)
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.preferredContentSize.width, height: self.preferredContentSize.height))
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        
        restofView = UIView(frame: CGRect(x: 0, y: self.preferredContentSize.height, width: self.preferredContentSize.width, height: self.preferredContentSize.height))
        restofView.backgroundColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        scrollView.addSubview(restofView)
        yToGoTo = self.preferredContentSize.height / 3
    }
    
    func setupSignUpButton() {
        signupButton = UIButton(frame: CGRect(x: 0, y: self.preferredContentSize.height - 60, width: self.preferredContentSize.width, height: 60))
        //rgb(29, 209, 161)
        let buttonColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        signupButton.backgroundColor = buttonColor
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        //rgb(255, 159, 243)
        let selectedColor = UIColor(red: 255/255, green: 159/255, blue: 243/255, alpha: 1.0)
        signupButton.setBackgroundColor(selectedColor, for: .highlighted)
        signupButton.addTarget(self, action: #selector(signupClicked), for: .touchUpInside)
        scrollView.addSubview(signupButton)
    }
    
    @objc func signupClicked() {
        if (emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || usernameTextField.text == "") {
            let alert = UIAlertController(title: "Can't login", message: "Please don't leave any fields blank", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        UserAuthHelper.createUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != "" {
                let alert = UIAlertController(title: "Can't Sign Up", message: error, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "signedup", sender: self)
            }
        }
    }
    
    func setUpTextFields() {
        let offset = self.preferredContentSize.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        nameTextField = UITextField(frame: CGRect(x: offset, y: 50, width: self.preferredContentSize.width - offset * 2, height: 50))
        nameTextField.setUpLogInTextFields()
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        nameTextField.tag = 1
        nameTextField.delegate = self
        scrollView.addSubview(nameTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: offset, y: 120, width: self.preferredContentSize.width - offset * 2, height: 50))
        usernameTextField.setUpLogInTextFields()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        usernameTextField.tag = 2
        usernameTextField.delegate = self
        scrollView.addSubview(usernameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: offset, y: 190, width: self.preferredContentSize.width - offset * 2, height: 50))
        emailTextField.setUpLogInTextFields()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        emailTextField.tag = 3
        emailTextField.delegate = self
        scrollView.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: offset, y: 260, width: self.preferredContentSize.width - offset * 2, height: 50))
        passwordTextField.setUpLogInTextFields()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 4
        passwordTextField.delegate = self
        scrollView.addSubview(passwordTextField)
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            next.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            signupClicked()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offset = textField.frame.origin.y - yToGoTo!
        if offset > 0 {
            let point = CGPoint(x: 0, y: offset)
            self.scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
    }
}
