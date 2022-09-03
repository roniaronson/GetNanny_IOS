

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterView: UIViewController {


    @IBOutlet weak var reg_TXT_email: UITextField!
    
    @IBOutlet weak var reg_TXT_password: UITextField!
    @IBOutlet weak var reg_TXT_name: UITextField!
    @IBOutlet weak var reg_TXT_phone: UITextField!
    @IBOutlet weak var reg_LBL_error: UILabel!
    
    @IBOutlet weak var reg_BTN_register: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        reg_BTN_register.tintColor = UIColor(red: 251/255, green: 182/255, blue: 128/255, alpha: 1)    }
    
    func setUpElements() {
    
        // Hide the error label
       reg_LBL_error.alpha = 0
    
        // Style the elements
        Utilities.styleTextField(reg_TXT_email)
        Utilities.styleTextField(reg_TXT_password)
        Utilities.styleTextField(reg_TXT_name)
        Utilities.styleTextField(reg_TXT_phone)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if reg_TXT_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            reg_TXT_password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            reg_TXT_name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            reg_TXT_phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = reg_TXT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "The password is illigal"
        }
        
        return nil
    }
    
    
    func showError(_ message:String) {
        
        reg_LBL_error.text = message
        reg_LBL_error.alpha = 1
    }
    
    func transitionToHome() {
        
        let tabView = storyboard?.instantiateViewController(identifier: "TabVC") as? TabView
        view.window?.rootViewController = tabView
        view.window?.makeKeyAndVisible()
        
    }


    @IBAction func registerClicked(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let email = reg_TXT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = reg_TXT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = reg_TXT_name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = reg_TXT_phone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["email":email, "password":password, "name":name, "phone":phone, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                }    }
    
            
            
        }
    }
    

}
