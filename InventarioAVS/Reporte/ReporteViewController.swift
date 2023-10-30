//
//  ReporteViewController.swift
//  InventarioAVS
//
//  Created by Ruben  Omar Campos Vazquez on 05/02/22.
//

import UIKit

class ReporteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, qrReaderProtocol {
    func qrReadit(qr: String) {
//        self.loading?.showLoadingView()
        search.text = qr
        search.delegate?.searchBar?(search, textDidChange: qr)
        self.resultCount = qr.count - 1
//        getFilteredData(data: qr)
    }
    var resultCount = 0
    var cargando = false
    var off = 0
    var deviceDes = true
    var devices = [movimiento]()
    @IBOutlet weak var Anim: UIActivityIndicatorView!
    var loading : LoadingView?
    var searchText = ""
    var filteredDevices = [movimiento]()
    var dispatchGroup : DispatchGroup?
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableReportes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReportes.backgroundColor = .clear
        tableReportes.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        hideKeyboardWhenTappedAround()
        loading = LoadingView()
        self.view.addSubview(loading!)
        
        getData(offset: off)
        search.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Anim.isHidden = true
       
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deviceDes = false

        if searchText != ""
        {
            self.searchText = searchText
            cargando = false
            off=0
            getFilteredData(data : searchText)
        }
        else
        {
            self.resultCount = 0
            self.searchText = ""
            off+=1
            deviceDes = true
            self.filteredDevices.removeAll()
        }
        
        self.tableReportes.reloadData()
    }
    
    func getFilteredData(data : String)
    {
        if !cargando
        {
            Anim.isHidden = false
            Anim.startAnimating()
            
            cargando = true
            off+=1
            requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos/filter/\(data)?offset=\(off)&limit=20") { (httpcode, dataResponse) in
                self.cargando = false
                self.resultCount+=1
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    if self.off > 1
                    {
                        self.resultCount-=1
                        for x in dataResponse!.data!
                        {
                            self.filteredDevices.append(x)
                        }
                    }
                    else
                    {
                        self.filteredDevices = dataResponse!.data!
                    }
                    
                    DispatchQueue.main.async {
                        self.loading?.hideLoadingView()
                        self.tableReportes.reloadData()
                        if self.searchText.count == self.resultCount
                        {
                            self.Anim.isHidden = true
                            
                        }
                    }
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        self.loading?.hideLoadingView()
                        if self.searchText.count == self.resultCount
                        {
                            self.Anim.isHidden = true
                            
                        }
                    }
                    
                }
                self.dispatchGroup?.leave()
            }
        }
    }
    @IBAction func CamreOpen(_ sender: UIButton) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func getData(offset : Int)
    {
        if !cargando
        {
            
            loading?.showLoadingView()
            cargando = true
            off+=1
            requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos?offset=\(off)&limit=20") { (httpcode, dataResponse) in
                self.cargando = false
                if evaluateResponse(controller: self, httpCode: httpcode)
                {
                    for x in dataResponse!.data!
                    {
                        self.devices.append(x)
                    }
                    DispatchQueue.main.async {
                        self.loading?.hideLoadingView()
                        self.tableReportes.reloadData()
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            
            cell.marca.text = filteredDevices[indexPath.row].dispositivo?.codigo
            cell.modelo.text = filteredDevices[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = filteredDevices[indexPath.row].dispositivo?.producto
            cell.lugar.text = filteredDevices[indexPath.row].lugar?.lugar
        }
        else
        {
            cell.marca.text = devices[indexPath.row].dispositivo?.codigo
            cell.modelo.text = devices[indexPath.row].lugar?.fechaAlta?.setDateProperly()
            cell.nombre.text = devices[indexPath.row].dispositivo?.producto
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
            vc.historia = filteredDevices[indexPath.row]
        }
        else
        {
            vc.historia = devices[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset

            if distanceFromBottom < height {
                if deviceDes
                {
                    if devices.count % 20 == 0
                    {
                        self.getData(offset:off)
                    }
                    
                }
                else
                {
                    if filteredDevices.count % 20 == 0
                    {
                        self.getFilteredData(data: self.searchText)
                    }
                }
            }
    }

}

extension String
{
    func setDateProperly()->String
    {
        let index = self.index(self.startIndex, offsetBy: 10)
        let mySubstring = self[..<index] // Hello
        return String(mySubstring)
    }
}
