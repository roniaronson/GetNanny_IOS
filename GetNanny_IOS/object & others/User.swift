

import Foundation

struct User {
    var user_id: String
    var email: String
    var password: String
    var name: String
    var phone: String

    
    init() {
        self.user_id = ""
        self.email = ""
        self.password = ""
        self.name = ""
        self.phone = ""
    }
    
    init(user_id: String, email: String, password: String, name: String, phone: String) {
        self.user_id = user_id
        self.email = email
        self.password = password
        self.name = name
        self.phone = phone
    }
}
