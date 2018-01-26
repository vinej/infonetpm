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
            self.address?.decode(data)
            self.code                     = BaseRec.decodeString(data[#keyPath(Company.code)])
            self.name                     = BaseRec.decodeString(data[#keyPath(Company.name)])
            self.type                     = BaseRec.decodeString(data[#keyPath(Company.type)])
            
            if (isSync) {
                self.isSync = true
            }
        }
    }
}
