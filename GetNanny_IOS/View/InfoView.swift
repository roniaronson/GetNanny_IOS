

import UIKit
import FirebaseStorage

class InfoView: UIViewController {

    @IBOutlet weak var info_IMG_image: UIImageView!
    @IBOutlet weak var info_LBL_info: UILabel!
    
    @IBOutlet weak var info_BTN_whatsapp: UIButton!
    var post: Post?
    var tempInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        info_BTN_whatsapp.tintColor = UIColor(red: 251/255, green: 182/255, blue: 128/255, alpha: 1)
        loadInfo()
    }
    
    func loadInfo() {
        if self.post != nil {
            self.tempInfo.append(self.post!.name)
            self.tempInfo.append(self.post!.type)
            self.tempInfo.append(self.post!.description)
            self.tempInfo.append("Price: " + self.post!.price)
            
            info_LBL_info.adjustsFontSizeToFitWidth = true
            info_LBL_info.numberOfLines = 16
            info_LBL_info.text = self.tempInfo.joined(separator: "\n\n")
            
            loadImage()
        }
    }
    
    func loadImage() {
        info_IMG_image.setRounded()
        let tempUserID = self.post?.user_id
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
                self.info_IMG_image.image = image
                
            }
        }

    }
    

    @IBAction func sendMessage(_ sender: Any) {
        let phone: String = post!.phone
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phone)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
    
    
}
