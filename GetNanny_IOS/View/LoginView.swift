

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class LoginView: UIViewController {
    @IBOutlet weak var login_TXT_email: UITextField!
    @IBOutlet weak var login_TXT_password: UITextField!
    @IBOutlet weak var login_LBL_error: UILabel!
    
    @IBOutlet weak var login_BTN_register: UIButton!
    @IBOutlet weak var login_BTN_login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        login_BTN_login.tintColor = UIColor(red: 251/255, green: 182/255, blue: 128/255, alpha: 1)
        login_BTN_register.tintColor = UIColor(red: 251/255, green: 182/255, blue: 128/255, alpha: 1)
        
    }
    
    func setUpElements() {
        // Hide the error label
        login_LBL_error.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(login_TXT_password)
        Utilities.styleTextField(login_TXT_email)
    }

    @IBAction func loginClicked(_ sender: Any) {
                
        // Create cleaned versions of the text field
        let email = login_TXT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = login_TXT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.login_LBL_error.text = error!.localizedDescription
                self.login_LBL_error.alpha = 1
            } else {
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let tabView = storyboard?.instantiateViewController(identifier: "TabVC") as? TabView
        view.window?.rootViewController = tabView
        view.window?.makeKeyAndVisible()
    }
    
}
