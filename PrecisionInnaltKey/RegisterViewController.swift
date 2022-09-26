//
//  RegisterViewController.swift
//  WebAuthNMelio
//
//  Created by Srinivasan T on 20/05/22.
//

import UIKit
import InnaitPod
class RegisterViewController: UIViewController {
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var displayName: UITextField!

    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var outputMsg: UILabel!
    private var observer: NSObjectProtocol?
    var regResult = NSDictionary()
    let regM = RegisterManager()
    let configM = ConfigurationManager()
    let oauthM = oAuthManager()

    override func viewDidAppear(_ animated: Bool) {
        outputMsg.text = ""
        observer = NotificationCenter.default.addObserver(forName: .UserErrIn, object: nil, queue: nil) {_ in
            let returnString = UserDefaults.standard.string(forKey: "regError")
            self.outputMsg.text = returnString
              }
        
        observer = NotificationCenter.default.addObserver(forName: .UserRegisterIn, object: nil, queue: nil) {_ in
            self.didFinishRegIn()
        }
        configM.setConfig(url: "https://ikmelio.innaitkey.com/api/fido/", projectId: "innait", rpId: "ikmelio.innaitkey.com")

 
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
        super.viewDidDisappear(animated)
    }

  
    
    @IBAction func createAccount(_ sender: Any) {
//        RegisterListApiCall()
        guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
        regM.getRegisterRequest(anchor: window, userId: self.userId.text! , userRef: self.displayName.text! , description: self.descrip.text! )
    
    }


    public  func RegisterListApiCall() {

        let parameters = [:
    ] as NSDictionary
    print("Rest api json response ==> \(parameters)")

        RequestCall.requestCall(parameters,bodyContent: false, url1:"https://ikmelio.innaitkey.com/api/fido/getAssertionRequest?projectId=innait&rpId=ikmelio.innaitkey.com&externalRef=muser01", completion: {
        Result,statusDict in
        DispatchQueue.main.async {
                  }
              })
              // Do any additional setup after loading the view.
          }

                
    func didFinishRegIn() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        regM.RegisterListApiCall(completion: {
            Result in
            DispatchQueue.main.async {
                
              }
          })

    }
        
    
   
   
    @IBAction func tappedBackground(_ sender: Any) {
        outputMsg.text = ""
        self.view.endEditing(true)
    }
}

