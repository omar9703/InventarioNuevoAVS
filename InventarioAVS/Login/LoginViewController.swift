//
//  LoginViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 25/01/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.attributedPlaceholder = NSAttributedString(
            string: "User ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        passwordText.attributedPlaceholder = NSAttributedString(
            string: "Contraseña",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = ""
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
