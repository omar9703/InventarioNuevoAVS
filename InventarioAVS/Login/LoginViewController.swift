//
//  LoginViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 25/01/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    var loadingview : LoadingView?
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
        loadingview = LoadingView()
        self.view.addSubview(loadingview!)
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = ""
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        
        if userText.text != "" && passwordText.text != ""
        {
            loadingview?.showLoadingView()
            requestPetition(ofType: LoginResponse.self, typeRequest: .POST, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/usuarios/login", parameters:  ["username": userText.text, "password":passwordText.text]) { httpcode, response in
                DispatchQueue.main.async {
                    self.loadingview?.hideLoadingView()
                }
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                if let response = response
                {
                    
                    DispatchQueue.main.async {
                        print(response.data)
                        UsuarioData.SaveUser(user: response.data)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                    {
                                let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuController")
                                self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                    else
                    {
                        self.alertFunc(viewController: self, alertType: .incompleteInformation, message: "Error al iniciar sesión", titleAlert: "Error", titleButton: "Aceptar") { f in
                            debugPrint("error")
                        }
                    }
                }
                else
                {
                    self.alertFunc(viewController: self, alertType: .incompleteInformation, message: "Error en el servicio", titleAlert: "Error", titleButton: "Aceptar") { f in
                        debugPrint("error")
                    }
                }
            }
        }
        else
        {
            self.alertFunc(viewController: self, alertType: .incompleteInformation, message: "Ingresa tu usuario y/o contraseña", titleAlert: "Error", titleButton: "Aceptar") { f in
                debugPrint("error")
            }
        }
//        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuController")
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UsuarioData.GetUser()
        {
            let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuController")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

struct LoginResponse : Codable
{
    let app_code : String
    let data : loginUser
}


