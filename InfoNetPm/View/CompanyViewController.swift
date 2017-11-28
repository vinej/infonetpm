//
//  CompanyTableViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-27.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CompanyViewController: UITableViewController {
    
    var list : Results<Object>? = nil
    var company : Company? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        list = RealmHelper.all(Company.self)
    }
    
    // return from a view, the load is not launch, so reload on dirty
    override func viewWillAppear(_ animated: Bool) {
        if (RealmHelper.isCompanyDirty) {
            list = RealmHelper.all(Company.self)
            self.tableView.reloadData()
            RealmHelper.isCompanyDirty = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //company = list![indexPath.row] as? Company
        //self.performSegue(withIdentifier: "segueEditCompany", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueEditCompany") {
            let indexPath = tableView.indexPathForSelectedRow
            company = list![(indexPath?.row)!] as? Company
            let theDestination = (segue.destination as! CompanyEditViewController)
            theDestination.company = self.company
        } else {
            let theDestination = (segue.destination as! CompanyNewViewController)
            let newCompagnie = RealmHelper.new(Company())
            theDestination.company = newCompagnie as? Company
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
        
        let lbl = cell.viewWithTag(1) as! UILabel

        let cie = (list![indexPath.row] as! Company)
        
        lbl.text = "\(cie.name) : \(cie.id)"
    
        return cell
    }
    

  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            RealmHelper.del(list![indexPath.row])
            list = RealmHelper.all(Company.self)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
