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
    
    let numberOfObjectToSynchronize : Float = 9.0
    var isStop : Bool = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressView.progress = 0
        progress.stopAnimating()
        isStop = false
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doStartSynchro(_ sender: UIButton) {
        lblCurrentProgress.text = ""
        progressView.progress = 0
        progress.startAnimating()
        BG( {
                print("This is run on the background queue")
                RestAPI().sync(self)
            } )
    }
    
    @IBAction func doEndSynchro(_ sender: UIButton) {
        progress.stopAnimating()
    }
    
    @IBAction func doReset(_ sender: UIButton) {
    }
    
    public func setCurrentObject(_ objectName: String) {
        lblCurrentProgress.text = objectName + "\r\n" + lblCurrentProgress.text!
        progressView.progress = progressView.progress + (1.0 / (numberOfObjectToSynchronize * 2.0) )
    }
    
    public func stop() {
        progress.stopAnimating()
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
