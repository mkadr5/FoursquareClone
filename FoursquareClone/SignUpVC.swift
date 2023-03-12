//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Muhammet Kadir on 11.03.2023.
//

import UIKit
import Parse


class SignUpVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func registerBtn(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text
            user.signUpInBackground{(success,error) in
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username / Password ?")
        }
        
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!){(user , error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username / Password ?")
        }
        
    }
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            print("okkk")
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

