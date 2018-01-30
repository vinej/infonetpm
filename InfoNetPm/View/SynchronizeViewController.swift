//
//  SynchronizeViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-01-30.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import UIKit

public class SynchronizeViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var lblCurrentProgress: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doStartSynchro(_ sender: UIButton) {
        BG(  {
            print("This is run on the background queue")
            RestAPI().sync(self)
        } )
    }
    
    @IBAction func doEndSynchro(_ sender: UIButton) {
    }
    
    @IBAction func doReset(_ sender: UIButton) {
    }
    
    public func setCurrentObject(_ objectName: String) {
        lblCurrentProgress.text = objectName + "\r\n" + lblCurrentProgress.text!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
