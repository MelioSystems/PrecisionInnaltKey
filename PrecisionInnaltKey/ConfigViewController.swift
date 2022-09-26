//
//  ConfigViewController.swift
//  PrecisionInnaltKey
//
//  Created by Srinivasan T on 22/09/22.
//

import UIKit
import InnaitPod

class ConfigViewController: UIViewController {

    let configM = ConfigurationManager()

    @IBOutlet weak var rpId: UITextField!
    @IBOutlet weak var projectId: UITextField!
    @IBOutlet weak var url: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        configM.setConfig(url: self.url.text!, projectId: self.projectId.text!, rpId: self.rpId.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
