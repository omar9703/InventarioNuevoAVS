//
//  ReportPopUpViewController.swift
//  InventarioAVS
//
//  Created by Omar Campos on 30/10/23.
//

import UIKit

protocol ReporteDoneProtocol {
    func DoneReport()
}

class ReportPopUpViewController: UIViewController , UITextViewDelegate{
    var dev : Device?
    var dev2 : products?
    var delegate : ReporteDoneProtocol?
    @IBOutlet weak var nombrelabel: UILabel!
    @IBOutlet weak var serieLabel: UILabel!
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var codigoLabel: UILabel!
    @IBOutlet weak var textview: UITextView!
    var loading = LoadingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loading)
        textview.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nombrelabel.text = dev?.producto ?? dev2?.producto
        serieLabel.text = dev?.serie ?? dev2?.serie
        modeloLabel.text = dev?.modelo ?? dev2?.modelo
        marcaLabel.text = dev?.marca ?? dev2?.marca
        codigoLabel.text = dev?.codigo ?? dev2?.codigo
        
        textview.text = "Ingrese sus comentarios"
        textview.textColor = UIColor.lightGray
    }

    @IBAction func Send(_ sender: UIButton) {
        if textview.text != ""
        {
            loading.showLoadingView()
            requestPetition(ofType: Device.self, typeRequest: .POST, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/reportes", parameters: ["dispositivoId": self.dev?.id ?? self.dev2?.id ?? 0,"usuarioId":UsuarioData.GetUserId() ?? 0,"comentarios":textview.text!,"foto":""]) { code, data in
                switch code
                {
                case 200...299:
                    DispatchQueue.main.async {
                        self.loading.hideLoadingView()
                        self.alertFunc(viewController: self, alertType: .successfullRegistration) { _ in
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
                                self.delegate?.DoneReport()
                            }
                        }
                    }
                    break
                default:
                    DispatchQueue.main.async {
                        self.loading.hideLoadingView()
                        self.alerta(message: "Ocurrio un error en el servicio")
                    }
                    break
                }
            }
        }
        else
        {
            self.alerta(message: "Ingrese los comentarios", title: "Error")
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ingrese sus comentarios"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
