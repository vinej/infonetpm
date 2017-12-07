import Foundation
import RealmSwift

/*
// Define your models like regular Swift classes
protocol BaseCompany {
    var company : Company? { get set}
}
*/

public class Company: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""  // client, service provider, thirs party service
    @objc dynamic var address: Address? = Address()
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public static func getOptions(_ list : Results<Object>) -> [String] {
        var listSelection = RealmHelper.defaultSelection
        var index = 1
        for rec in list {
            let cie = rec as! Company
            listSelection.append( "\(cie.code ) | \(cie.name )")
            index = index + 1
        }
        return listSelection
    }
    
    public static func getCompany( _ value : String) -> Company {
        let index = value.firstIndex(of: "|")
        let code = value.slicing(from: 0, to: index! - 1)
        return RealmHelper.filter(Company.self, "code = %@", code!).first as! Company
    }
}
