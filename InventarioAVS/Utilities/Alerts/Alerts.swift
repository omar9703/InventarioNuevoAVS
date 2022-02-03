//
//  Alerts.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation
import UIKit

class alert {
    var titleAlert : String = ""
    var message : String = ""
    var buttonTitle : String = ""
}

enum typeAlert {
    case loading
    case sorryMessageResponse
    case sorryErrorConection
    case selectPaymentMethod
    case genericAlert
    case successfullRegistration
    case incompleteInformation
}


extension UIViewController{
    func alertFunc(viewController : UIViewController, alertType : typeAlert, message : String = "", titleAlert : String = "",titleButton : String = "",completion: @escaping (Bool)->Void){
        let messageAlert : alert = alert()
        switch alertType {
        case .loading:
            messageAlert.titleAlert = ""
            messageAlert.message = "Cargando"
            messageAlert.buttonTitle = ""
            break
        case .sorryErrorConection:
            messageAlert.titleAlert = "¡Lo sentimos!"
            messageAlert.message = "Hubo un error en tu conexión, intentelo de nuevo mas tarde"
            messageAlert.buttonTitle = "Cerrar"
            break
        case .sorryMessageResponse:
            messageAlert.titleAlert = "¡Lo sentimos!"
            messageAlert.message = message
            messageAlert.buttonTitle = "Cerrar"
            break
        case .selectPaymentMethod:
            messageAlert.titleAlert = "¡Lo sentimos!"
            messageAlert.message = "Seleccione un método de pago."
            messageAlert.buttonTitle = "Cerrar"
            break
        case .successfullRegistration:
            messageAlert.titleAlert = "¡Registro exitoso!"
            messageAlert.message = "Revisa tu correo electrónico para activar tu cuenta. Asegúrate de revisar el buzón de spam."
            messageAlert.buttonTitle = "Cerrar"
            break
        case .genericAlert:
            messageAlert.titleAlert = titleAlert
            messageAlert.message = message
            messageAlert.buttonTitle = titleButton
        case .incompleteInformation:
            messageAlert.titleAlert = "¡Lo sentimos!"
            messageAlert.message = "Por favor ingresa o corriga sus datos."
            messageAlert.buttonTitle = "Aceptar"
            break
        }
        
        let alert = UIAlertController(title: messageAlert.titleAlert, message: messageAlert.message , preferredStyle: .alert)
        if alertType != .loading{
            alert.addAction(UIAlertAction(title: messageAlert.buttonTitle, style: .default, handler: { al in
                completion(true)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func alerta(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
}
