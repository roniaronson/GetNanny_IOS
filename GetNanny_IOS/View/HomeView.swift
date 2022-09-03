

import UIKit
import FirebaseFirestore
import FirebaseStorage

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selected: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    var myData = [Post]()
    var tempInfo: [String] = []
    var tempName: String = ""
    var tempImage: String = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        readPosts()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let db = Firestore.firestore()
        db.collection("posts").whereField("user_id", isEqualTo: myData[indexPath.row].user_id).getDocuments() {
            (snapshot, err) in
            if let err = err {
                print("Error")
            }
            else {
                for d in snapshot!.documents {
                    var tempName = d["name"] as? String
                    var tempType = (d["type"] as? String)!
                    var tempDescription = d["about"] as? String
                    var tempPrice = "Price: "
                    tempPrice += (d["price"] as? String)!
                    
                    self.tempInfo.append(tempName!)
                    self.tempInfo.append(tempType)
                    self.tempInfo.append(tempDescription!)
                    self.tempInfo.append(tempPrice)
                    
                    var tempLbl = self.tempInfo.joined(separator: "\n")
                    
                    self.tempInfo.removeAll()
                    let tempUserID = d["user_id"] as? String
                    let start = tempUserID?.index(tempUserID!.startIndex, offsetBy: 0)
                    let end = tempUserID?.index(tempUserID!.startIndex, offsetBy: (tempUserID!.count - 1))
                    let range = start!...end!
                    var newID = String(tempUserID![range])
                    newID = "\"" + newID + "\""
                    
                    let storageRef = Storage.storage().reference()
                    let imgRef = storageRef.child("images/\(newID).jpg")
                    imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            //
                        } else {
                            let image = UIImage(data: data!)
                            cell.myImageView.image = image
                        }
                    }
                    
                    cell.myLabel.adjustsFontSizeToFitWidth = true
                    cell.myLabel.numberOfLines = 6
                    cell.myLabel.text = tempLbl
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfoView {
            destination.post = myData[(tableView.indexPathForSelectedRow?.row)!]
        }
        
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
    
    @IBAction func isSelected(_ sender: Any) {
        readPosts()
    }
    func readPosts() {
        let db = Firestore.firestore().collection("posts").getDocuments() { (snapshot, err) in
            self.myData.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for d in snapshot!.documents {
                    let post = Post(user_id: d["user_id"] as! String, name: d["name"] as! String, phone: d["phone"] as! String, image: "", description: d["about"] as! String, type: d["type"] as! String, price: d["price"] as! String)
                    if(self.selected.selectedSegmentIndex == 0){
                        if(post.type == "Babysitter"){
                            self.myData.append(post)
                        }
                        
                    }
                    else{
                        if(post.type == "Parent"){
                            self.myData.append(post)                        }
                    }
                                        
                   
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getNameAndImage(user_id: String) -> String {
        let db = Firestore.firestore().collection("users").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for d in snapshot!.documents {
                    var tempUserID = d["uid"] as! String
                    if user_id == tempUserID {
                        self.tempName = d["name"] as! String
                        print(self.tempName)
                    }
                }
            }
        }
        return self.tempName
    }    
}
