import Foundation
import RealmSwift

public class Company: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
