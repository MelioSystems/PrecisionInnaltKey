//
//  StartViewController.swift
//  WebAuthNMelio
//
//  Created by Srinivasan T on 20/05/22.
//

import UIKit
import InnaitPod
class StartViewController: UIViewController {
    let authM = AuthenticationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func UserTokenAction(_ sender: UIButton) {
        authM.getUserToken(tokenId: "", completion: {
            Result in
            DispatchQueue.main.async {
                // implement here
              }
          })
    }

    
    @IBAction func TransactionAuthenticateAction(_ sender: Any) {
        authM.getTransactionAssertionRequest(userId: "", userRef: "", externalRef: "", payload: "", hash: "", completion: {
            Result in
            DispatchQueue.main.async {
                // implement here
              }
          })
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
