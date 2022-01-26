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

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
extension UIView{
    func addBorders(borderWidth: CGFloat = 0.2, borderColor: CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    func addShadowToView(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
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
