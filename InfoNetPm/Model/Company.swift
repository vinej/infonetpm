import Foundation
import RealmSwift
 
public class Company: BaseRec {

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""  // client, service provider, thirs party service
    @objc dynamic var address: Address? = Address()
    
    public override func encode() -> [String: Any] {
        let address = self.address?.encode()
        return super.encode().merge(
            [
                #keyPath(Company.code) : self.code,
                #keyPath(Company.name) : self.name,
                #keyPath(Company.type) : self.type,
                #keyPath(Company.address) : address!
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.address?.decode(data[#keyPath(Company.address)] as! [String : Any] )
            self.code                     = data[#keyPath(Company.code)] as! String
            self.name                     = data[#keyPath(Company.name)] as! String
            self.type                     = data[#keyPath(Company.type)] as! String
            
            if (isSync) {
                self.isSync = true
            }
        }
    }
}
