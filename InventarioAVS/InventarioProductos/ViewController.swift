//
//  ViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 08/01/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, FilterSwitchProtocol, qrReaderProtocol {
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let alert = UIAlertController(title: nil, message: "Cargando", preferredStyle: .alert)
    @IBOutlet weak var qrButton: UIBarButtonItem!
    @IBOutlet weak var search: UISearchBar!
    var filtro = TypeFilter.nombre
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var deviceDes = true
    var devices = [Device]()
    var loading : LoadingView?
    var filteredDevices = [Device]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        productsTable.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        qrButton.isEnabled = false
        search.backgroundColor = .clear
        productsTable.backgroundColor = .clear
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        getData()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func openFilterView(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Filtro", bundle: nil).instantiateViewController(identifier: "filtro") as! FilterViewController
        vc.delegate = self
        vc.tipo = filtro
        self.present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getData()
    {
        self.loading?.showLoadingView()
        requestPetition(ofType: DeviceResponse.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/dispositivos?limit=3000") { (httpcode, dataResponse) in
            if evaluateResponse(controller: self, httpCode: httpcode)
            {
                self.devices.removeAll()
                self.devices = dataResponse!.data
                DispatchQueue.main.async {
                    self.loading?.hideLoadingView()
                    self.productsTable.reloadData()
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
            cell.lugar.text = filteredDevices[indexPath.row].lugar.lugar
        }
        else
        {
            cell.marca.text = devices[indexPath.row].marca
            cell.modelo.text = devices[indexPath.row].modelo
            cell.nombre.text = devices[indexPath.row].producto
            cell.lugar.text = devices[indexPath.row].lugar.lugar
            
        }
        cell.backgroundColor = .clear
        cell.marca.textColor = .white
        cell.modelo.textColor = .white
        cell.nombre.textColor = .white
        cell.lugar.textColor = .white
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Nombre"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .red
        headerView.addSubview(label)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: CGFloat(Int(tableView.frame.width / 2) - 75), y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label2.text = "Marca"
        label2.font = .systemFont(ofSize: 16)
        label2.textColor = .red
        headerView.addSubview(label2)
        
        let label3 = UILabel()
        label3.frame = CGRect(x: CGFloat(Int(tableView.frame.width / 2) + 25), y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label3.text = "Modelo"
        label3.font = .systemFont(ofSize: 16)
        label3.textColor = .red
        headerView.addSubview(label3)
        
        let label4 = UILabel()
        label4.frame = CGRect(x: CGFloat(Int(tableView.frame.width) - 70), y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label4.text = "Lugar"
        label4.font = .systemFont(ofSize: 16)
        label4.textColor = .red
        headerView.addSubview(label4)
        
        
        headerView.backgroundColor = UIColor(red: 19/255, green: 18/255, blue: 79/255, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
                    return item.modelo?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
                }
                break
            case .serie:
                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
                    return item.serie?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
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

