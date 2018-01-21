import Foundation
import RealmSwift

/*
// Define your models like regular Swift classes
protocol BaseCompany {
    var company : Company? { get set}
}
*/

public class Company: IPM {

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""  // client, service provider, thirs party service
    @objc dynamic var address: Address? = Address()
}
