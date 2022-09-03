
import Foundation
import FirebaseFirestore
import FirebaseAuth

class DB_Helper {
    
    var users = [User]()
    
    init(){
        self.users = getUsers()
    }
    
    func getUsers() -> [User]{
        var users = [User]()
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("in succsess")
                    for d in snapshot!.documents {
                        
                        let tempUser = User(user_id: d["user_id"] as! String, email: d["email"] as! String, password: d["password"] as! String, name: d["name"] as! String, phone: d["phone"] as! String)
                        users.append(tempUser)
                    }
                }
        }
        return users
    }
}
