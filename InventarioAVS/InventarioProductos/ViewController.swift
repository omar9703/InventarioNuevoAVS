//
//  ViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 08/01/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, FilterSwitchProtocol, qrReaderProtocol {
    @IBOutlet weak var totalrows: UILabel!
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
    var cargandoFilter = false
    var searchtext = ""
    var filteredDevices = [products]()
    var cargando = false
    var off = 0
    var offFilter = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        productsTable.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        qrButton.isEnabled = true
        search.backgroundColor = .clear
        productsTable.backgroundColor = .clear
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        getData(offset: off)
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
    
    func getData(offset : Int)
    {
        debugPrint(cargando)
        if !cargando
        {
            cargando = true
            off+=1
            self.loading?.showLoadingView()
            requestPetition(ofType: DeviceResponse.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/dispositivos?limit=50&offset=\(off)") { (httpcode, dataResponse) in
                self.cargando.toggle()
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    
                    for x in dataResponse!.data
                    {
                        self.devices.append(x)
                    }
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
    }
    
    func getfilterData()
    {
        if !cargandoFilter
        {
            cargandoFilter = true
            offFilter+=1
            self.loading?.showLoadingView()
            requestPetition(ofType: filterResponse.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/dispositivos/filterdeviceFields?limit=30&offset=\(offFilter)",header: searchtext) { (httpcode, dataResponse) in
                self.cargandoFilter.toggle()
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    debugPrint(dataResponse?.data.count)
                    if dataResponse?.data.count ?? 0 < 30
                    {
                        self.cargandoFilter = true
                    }
                    else
                    {
                        self.cargandoFilter = false
                    }
                    for x in dataResponse!.data
                    {
                        self.filteredDevices.append(x)
                    }
                    DispatchQueue.main.async {
                        self.totalrows.text =  "Total de articulos: \(dataResponse?.total_rows ?? 0) "
                        self.loading?.hideLoadingView()
                        self.productsTable.reloadData()
                    }
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        self.loading?.hideLoadingView()
                        self.productsTable.reloadData()
                    }
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
            cell.lugar.text = filteredDevices[indexPath.row].lugar
        }
        else
        {
            cell.marca.text = devices[indexPath.row].marca
            cell.modelo.text = devices[indexPath.row].modelo
            cell.nombre.text = devices[indexPath.row].producto
            cell.lugar.text = devices[indexPath.row].lugar?.lugar
            
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
            vc.device2 = filteredDevices[indexPath.row]
        }
        else
        {
            vc.device = devices[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let hStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        hStackView.alignment = .center
        hStackView.distribution = .fillEqually
        hStackView.spacing = 2
        hStackView.axis = .horizontal
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: 100, height: headerView.frame.height-10)
        label.text = "Nombre"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .red
        label.textAlignment = .center
        hStackView.addArrangedSubview(label)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: 0, y: 5, width: 100, height: headerView.frame.height-10)
        label2.text = "Marca"
        label2.font = .systemFont(ofSize: 16)
        label2.textColor = .red
        label2.textAlignment = .center
        hStackView.addArrangedSubview(label2)
        
        let label3 = UILabel()
        label3.frame = CGRect(x: 0, y: 5, width: 100, height: headerView.frame.height-10)
        label3.text = "Modelo"
        label3.font = .systemFont(ofSize: 16)
        label3.textColor = .red
        label3.textAlignment = .center
        hStackView.addArrangedSubview(label3)
        
        let label4 = UILabel()
        label4.frame = CGRect(x: 0, y: 5, width: 100, height: headerView.frame.height-10)
        label4.text = "Lugar"
        label4.font = .systemFont(ofSize: 16)
        label4.textColor = .red
        label4.textAlignment = .center
        hStackView.addArrangedSubview(label4)
        
        headerView.addSubview(hStackView)
        headerView.backgroundColor = UIColor(red: 19/255, green: 18/255, blue: 79/255, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""
        {
            searchtext = searchText
            deviceDes = false
//            switch filtro {
//            case .nombre:
//                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
//                    return item.producto.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
//                }
//                break
//            case .codigo:
//                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
//                    return item.codigo.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
//                }
//                break
//            case .marca:
//                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
//                    return item.marca.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
//                }
//                break
//            case .modelo:
//                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
//                    return item.modelo?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
//                }
//                break
//            case .serie:
//                filteredDevices = searchText.isEmpty ? devices : devices.filter{(item: Device) ->Bool in
//                    return item.serie?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
//                }
//                break
//
//            }
            self.offFilter = 1
            requestPetition(ofType: filterResponse.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/dispositivos/filterdeviceFields?limit=30&offset=\(1)",header: searchText) { (httpcode, dataResponse) in
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    debugPrint(dataResponse?.data.count)
                    
                    if dataResponse?.data.count ?? 0 < 30
                    {
                        self.cargandoFilter = true
                    }
                    else
                    {
                        self.cargandoFilter = false
                    }
                    self.filteredDevices.removeAll()
                    self.filteredDevices = dataResponse?.data ?? [products]()
                    DispatchQueue.main.async {
                        self.totalrows.isHidden = false
                        self.totalrows.text =  "Total de articulos: \(dataResponse?.total_rows ?? 0) "
                        self.productsTable.reloadData()
                    }
                    
                }
                else
                {
                    
                }
            }
            
        }
        else
        {
            deviceDes = true
            totalrows.isHidden = true
            filteredDevices.removeAll()
            self.productsTable.reloadData()
        }
        
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset

            if distanceFromBottom < height {
                if deviceDes
                {
                    self.getData(offset:off)
                    
                    debugPrint("final")
                }
                else
                {
                    self.getfilterData()
                }
            }
    }
}

