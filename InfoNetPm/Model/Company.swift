import Foundation
import RealmSwift

public class Company: BaseRec {

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""  // client, service provider, thirs party service
    @objc dynamic var address: Address? = Address()
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
        [
            #keyPath(Company.code) : self.code,
            #keyPath(Company.name) : self.name,
            #keyPath(Company.type) : self.type
        ])
    }
    
    public override func decode(_ data: [String: Any]) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.code                     = decodeString(data[#keyPath(Company.code)])
            self.name                     = decodeString(data[#keyPath(Company.name)])
            self.type                     = decodeString(data[#keyPath(Company.type)])
        }
    }
}
