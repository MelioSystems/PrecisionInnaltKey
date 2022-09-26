/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view where the user can sign in, or create an account.
*/

import AuthenticationServices
import UIKit
import os
import InnaitPod

class SignInViewController: UIViewController{
    
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var externalRef: UITextField!
    @IBOutlet weak var outputMsg: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var prompt: UITextField!
    private var observer: NSObjectProtocol?
    var regResult = NSDictionary()
    let authM = AuthenticationManager()
    let configM = ConfigurationManager()

    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//

        outputMsg.text = ""
        

        observer = NotificationCenter.default.addObserver(forName: .UserSignIn, object: nil, queue: nil) {_ in
            self.didFinishSignIn()
        }
//        guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
//        (UIApplication.shared.delegate as? //AppDelegate)?.accountManager.signInWith(anchor: window)
        observer = NotificationCenter.default.addObserver(forName: .UserErrIn, object: nil, queue: nil) {_ in
            let returnString = UserDefaults.standard.string(forKey: "regError")
            self.outputMsg.text = returnString
              }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
        super.viewDidDisappear(animated)
    }

    @IBAction func loginAction(_ sender: UIButton) {
        guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
        authM.getAssertionRequest(externalRef: "fbdfvbd", anchor: window)
    }
    
  
    func didFinishSignIn() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            authM.LogInApiCall(reason: self.reason.text!, title: self.titleText.text!, prompt: self.prompt.text!, completion: { Result in
                DispatchQueue.main.async {
                    
                  }
              })
        }
       
    }
    
    @IBAction func tappedBackground(_ sender: Any) {
        self.view.endEditing(true)
    }
}

