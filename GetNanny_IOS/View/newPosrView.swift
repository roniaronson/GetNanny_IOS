

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage


class newPostView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var type: [String] = []
    var name: String = ""
    var phone: String = ""
    
    @IBOutlet weak var post_TXT_about: UITextField!
    @IBOutlet weak var post_TXT_price: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var post_BTN_post: UIButton!
    override func viewDidLoad() {
        image.setRounded()
        super.viewDidLoad()
        getCurrUser()
        post_BTN_post.tintColor = UIColor(red: 251/255, green: 182/255, blue: 128/255, alpha: 1)
        
    }
    
    func getCurrUser() {
        var uID: String = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: uID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("err")
            } else {
                for d in querySnapshot!.documents {
                    self.name = d["name"] as! String
                    self.phone = d["phone"] as! String
                }
            }
        }
    }
    
    @IBAction func eng_BTN_sel(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            type.remove(at: type.firstIndex(of: "Babysitter")!)
        } else {
            sender.isSelected = true
            type.append("Babysitter")
        }
    }
    
    @IBAction func geo_BTN_sel(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            type.remove(at: type.firstIndex(of: "Parent")!)
        } else {
            sender.isSelected = true
            type.append("Parent")
        }
    }

    
    @IBAction func postClicked(_ sender: Any) {
        
        uploadToFB()
        // Create cleaned versions of the data
        let about = post_TXT_about.text!
        let price = post_TXT_price.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // User was created successfully, now store the first name and last name
        let db = Firestore.firestore()
        let tempType = type.joined(separator: " ")
        db.collection("posts").addDocument(data: ["user_id":Auth.auth().currentUser?.uid, "name":self.name, "phone":self.phone, "type":tempType, "about":about, "price":price]) { (error) in
        }
        
        // Transition to the home screen
        self.transitionToHome()
    }
    
    func transitionToHome() {
        
        let tabView = storyboard?.instantiateViewController(identifier: "TabVC") as? TabView
        view.window?.rootViewController = tabView
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.image.image = image
        dismiss(animated: true)
    }
    
    func uploadToFB() {
        
        guard image != nil else {
            return
        }
            
        let storageRef = Storage.storage().reference()
        let imageData = image.image?.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        
        let tempUserID = Auth.auth().currentUser?.uid
        let start = tempUserID?.index(tempUserID!.startIndex, offsetBy: 0)
        let end = tempUserID?.index(tempUserID!.startIndex, offsetBy: (tempUserID!.count - 1))
        let range = start!...end!
        var newID = String(tempUserID![range])
        newID = "\"" + newID + "\""
        
        let fileRef = storageRef.child("images/\(newID).jpg")
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                //
            }
        }
    }
}
