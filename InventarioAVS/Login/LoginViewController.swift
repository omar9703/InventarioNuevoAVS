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
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Usuario")
          
          //3
          do {
            let usuario = try managedContext.fetch(fetchRequest)
              print(usuario.last?.value(forKey: "nombre"))
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
//        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuController")
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPetition(ofType: LoginResponse.self, typeRequest: .POST, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/usuarios/login", parameters:  ["username": "leon", "password":"123456"]) { httpcode, response in
            print("hola", response)
            if let response = response
            {
                DispatchQueue.main.async {
                    self.saveUser(user: response.data)
                }
                
            }
        }
    }
    func saveUser(user: loginUser) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Usuario",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
        person.setValue(user.nombre, forKeyPath: "nombre")
        person.setValue(user.apellidoMaterno, forKey: "apellidoMaterno")
      
      // 4
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
}

struct LoginResponse : Codable
{
    let app_code : String
    let data : loginUser
}

struct loginUser : Codable
{
    let apellidoMaterno : String
    let apellidoPaterno : String
    let correo : String
    let fechaAlta : String
    let fechaUltimaModificacion : String
    let foto : String
    let id : Int
    let nombre : String
    let rolId : Int
    let telefono : String
    let username : String
}
struct Rol : Codable
{
    let id : Int
    let nombre : String
}
