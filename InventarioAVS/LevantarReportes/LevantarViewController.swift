//
//  LevantarViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 16/02/22.
//

import UIKit

class LevantarViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, textViewTextProtocol, qrReaderProtocol {
    
    var comentarios = ""
    var phtobase64 = ""
    var cargandoFilter = false
    @IBOutlet weak var tableReporte: UITableView!
    @IBOutlet weak var agregarFoto: UIButton!
    @IBOutlet weak var searchCamera: UIButton!
    @IBOutlet weak var testsearch: UISearchBar!
    var imagenDispositivo : UIImage?
    var deviceFiltered : products?
    var device : Device?
    var deviceDes = true
    var descripcionReport = false
    var devices : Reportes?
    var loading : LoadingView?
    var filteredDevices = [Datum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        testsearch.delegate = self
        tableReporte.delegate = self
        tableReporte.dataSource = self
        tableReporte.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableReporte.register(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        tableReporte.register(UINib(nibName: "DescripcionTableViewCell", bundle: nil), forCellReuseIdentifier: "cell3")
        tableReporte.register(UINib(nibName: "ImagenTableViewCell", bundle: nil), forCellReuseIdentifier: "cell4")
        
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        getDevices()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func sendRequest(_ sender: UIBarButtonItem) {
        if let d = device
        {
            if comentarios != "" && phtobase64 != ""
            {
                loading?.showLoadingView()
                requestPetition(ofType: Device.self, typeRequest: .POST, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/reportes", parameters: ["dispositivoId":deviceDes ? d.id! : deviceFiltered!.id,"usuarioId":UsuarioData.GetUserId() ?? 0,"comentarios":comentarios,"foto":phtobase64]) { code, data in
                    switch code
                    {
                    case 200...299:
                        DispatchQueue.main.async {
                            self.loading?.hideLoadingView()
                            self.alertFunc(viewController: self, alertType: .successfullRegistration) { _ in
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                        break
                    default:
                        DispatchQueue.main.async {
                            self.loading?.hideLoadingView()
                            self.alerta(message: "Ocurrio un error en el servicio")
                        }
                        break
                    }
                }
            }
            else
            {
                self.alerta(message: "Seleccione una imagen y/o introduzca sus comentarios", title: "Error")
            }
        }
        else
        {
            self.alerta(message: "Seleccione un dispositivo", title: "Error")
        }
    }
    @IBAction func openQRCamera(_ sender: UIButton) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("ag")
        view.endEditing(true)
    }
    func getDevices()
    {
        self.loading?.showLoadingView()
        requestPetition(ofType: Reportes.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/reportes?limit=30&offset=1") { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                
                self.devices = dataResponse
                DispatchQueue.main.async {
                    self.loading?.hideLoadingView()
                    self.tableReporte.reloadData()
                }
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.loading?.hideLoadingView()

                }
                
            }
        }
    }
    func qrReadit(qr: String) {
        testsearch.delegate?.searchBar?(testsearch, textDidChange: qr)
        testsearch.text = qr
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !descripcionReport
        {
        if !deviceDes
        {
        return filteredDevices.count
        }
        else
        {
            return devices?.data.count ?? 0
        }
        }
        else
        {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !descripcionReport
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
//        if !deviceDes
//        {
//            
//            cell.marca.text = filteredDevices[indexPath.row].dispositivo.marca
//            cell.modelo.text = filteredDevices[indexPath.row].dispositivo.descompostura
//            cell.nombre.text = filteredDevices[indexPath.row].dispositivo.producto
//            cell.lugar.text = filteredDevices[indexPath.row].dispositivo.lugar?.lugar
//        }
//        else
//        {
            cell.marca.text = devices?.data[indexPath.row].dispositivo?.marca
            cell.modelo.text = devices?.data[indexPath.row].comentarios
            cell.nombre.text = devices?.data[indexPath.row].dispositivo?.producto
            cell.lugar.text =  devices?.data[indexPath.row].dispositivo?.lugar?.lugar
            
//        }
        cell.backgroundColor = .clear
        cell.marca.textColor = .white
        cell.modelo.textColor = .white
        cell.nombre.textColor = .white
            cell.lugar.textColor = .white
            cell.selectionStyle = .none
        return cell
        }
        else
        {
            if indexPath.row < 2
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ProductDetailTableViewCell
                cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if indexPath.row == 0
            {
                cell.titulo.text = "Nombre"
                if !deviceDes
                {
                    cell.descripcion.text = deviceFiltered?.producto
                }
                else
                {
                    cell.descripcion.text = device?.producto
                }
            }
            else if indexPath.row == 1
            {
                cell.titulo.text = "Codigo"
                if !deviceDes
                {
                    cell.descripcion.text = deviceFiltered?.codigo
                }
                else
                {
                    cell.descripcion.text = device?.codigo
                }
            }
            return cell
            }
            else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DescripcionTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.delegate = self
                cell.cometarios.text = comentarios
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ImagenTableViewCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                if let _ = imagenDispositivo
                {
                    cell.imagen.image = imagenDispositivo!
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        deviceDes = false
//        device = nil
//        descripcionReport = false
//        agregarFoto.isEnabled = false
//        if searchText != ""
//        {
//            requestPetition(ofType: filterResponse.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/dispositivos/filterdeviceFields?limit=30&offset=\(1)",header: searchText) { (httpcode, dataResponse) in
//                if evaluateResponse(controller: self, httpCode: httpcode)
//                {
//                    debugPrint(dataResponse?.data.count)
//                    
//                    if dataResponse?.data.count ?? 0 < 30
//                    {
//                        self.cargandoFilter = true
//                    }
//                    else
//                    {
//                        self.cargandoFilter = false
//                    }
//                    self.filteredDevices.removeAll()
//                    self.filteredDevices = dataResponse?.data ?? [Datum]()
//                    DispatchQueue.main.async {
//                        self.tableReporte.reloadData()
//                    }
//                    
//                }
//                else
//                {
//                    
//                }
//            }
//        }
//        else
//        {
//            deviceDes = true
//            filteredDevices.removeAll()
//        }
//        
//        self.tableReporte.reloadData()
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !descripcionReport
//        {
//        descripcionReport = true
//            agregarFoto.isEnabled = true
//            if !deviceDes
//            {
//                deviceFiltered = filteredDevices[indexPath.row]
//            }
//            else
//            {
//                device = devices[indexPath.row]
//            }
//        tableReporte.reloadData()
//        }
//    }
    @IBAction func addPhotoAction(_ sender: UIButton) {
        self.showAlert()
    }
    func getComentarios(comen: String) {
        comentarios = comen
//        print(comen)
    }
}

extension LevantarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    private func showAlert() {
if descripcionReport
        {
    let alert = UIAlertController(title: "Seleccion de Imagen", message: "Origen de la imagen", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: {(action: UIAlertAction) in
        self.getImage(fromSourceType: .camera)
    }))
    alert.addAction(UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
        self.getImage(fromSourceType: .photoLibrary)
    }))
    alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
    self.present(alert, animated: true, completion: nil)
}
        }

        //get image from source type
        private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

            //Check is source type available
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {

                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = sourceType
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            self.dismiss(animated: true) { [weak self] in

                guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
                //Setting image to your image view
                self?.imagenDispositivo = image
                self?.phtobase64 = self?.convertImageToBase64String(img: image) ?? ""
                DispatchQueue.main.async {
                    self?.tableReporte.reloadData()
                }
                
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}
