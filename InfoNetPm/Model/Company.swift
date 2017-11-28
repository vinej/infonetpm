import Foundation
import RealmSwift

public class Company: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var type = ""  // client, service provider, thirs party service
    override public static func primaryKey() -> String? {
        return "id"
    }
}
