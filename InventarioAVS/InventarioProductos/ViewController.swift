//
//  ViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 08/01/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, FilterSwitchProtocol, qrReaderProtocol {
    
    
    
    @IBOutlet weak var qrButton: UIBarButtonItem!
    @IBOutlet weak var search: UISearchBar!
    var filtro = TypeFilter.nombre
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var deviceDes = true
    var devices = Devices()
    var filteredDevices = Devices()
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTable.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        qrButton.isEnabled = false
        search.backgroundColor = .clear
        productsTable.backgroundColor = .clear
        setNavigationBar()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func setNavigationBar() {

        let imgBackArrow = UIImage(named: "ARROW")!
        let y = resizeImage(image: imgBackArrow, targetSize: CGSize(width: 25, height: 25))
        
        navigationController?.navigationBar.backIndicatorImage = y
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = y

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backButtonTitle = ""
    }

    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openFilterView(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Filtro", bundle: nil).instantiateViewController(identifier: "filtro") as! FilterViewController
        vc.delegate = self
        vc.tipo = filtro
        self.present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData()
    {
        requestPetition(ofType: Devices.self, typeRequest: .GET, url: urlAVSdevice.devices) { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                print(dataResponse?.count)
                self.devices = dataResponse!
                DispatchQueue.main.async {
                    self.productsTable.reloadData()
                }
                
            }
        }
    }

    @IBAction func qrOpenCamera(_ sender: UIBarButtonItem) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !deviceDes
        {
        return filteredDevices.count
        }
        else
        {
            return devices.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
        if !deviceDes
        {
            
            cell.marca.text = filteredDevices[indexPath.row].marca
            cell.modelo.text = filteredDevices[indexPath.row].modelo
            cell.nombre.text = filteredDevices[indexPath.row].producto
        }
        else
        {
            cell.marca.text = devices[indexPath.row].marca
            cell.modelo.text = devices[indexPath.row].modelo
            cell.nombre.text = devices[indexPath.row].producto
            
        }
        cell.backgroundColor = .clear
        cell.marca.textColor = .white
        cell.modelo.textColor = .white
        cell.nombre.textColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if !deviceDes
        {
            vc.device = filteredDevices[indexPath.row]
        }
        else
        {
            vc.device = devices[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deviceDes = false
        if searchText != ""
        {
            switch filtro {
            case .nombre:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.producto.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
            case .codigo:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.codigo.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
            case .marca:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.marca.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
            case .modelo:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.modelo.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
            case .serie:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.serie.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
                
            }
            
        }
        else
        {
            deviceDes = true
            filteredDevices.removeAll()
        }
        
        self.productsTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deviceDes = true
        self.productsTable.reloadData()
    }
    func ChangeSwitchFilter(filtro: TypeFilter) {
        self.filtro = filtro
        switch filtro {
        case .nombre:
            self.filterButton.title = "Filtro : Nombre"
            qrButton.isEnabled = false
            break
        case .marca:
            self.filterButton.title = "Filtro : Marca"
            qrButton.isEnabled = false
            break
        case .modelo:
            self.filterButton.title = "Filtro : Modelo"
            qrButton.isEnabled = false
            break
        case .serie:
            self.filterButton.title = "Filtro : Serie"
            qrButton.isEnabled = false
            break
        case .codigo:
            self.filterButton.title = "Filtro : Codigo"
            qrButton.isEnabled = true
            break
        
        }
    
    }
    func qrReadit(qr: String) {
        search.delegate?.searchBar?(search, textDidChange: qr)
        search.text = qr
        
    }
}

