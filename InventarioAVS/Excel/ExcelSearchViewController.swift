//
//  ExcelSearchViewController.swift
//  InventarioAVS
//
//  Created by Omar Campos on 21/07/25.
//

import UIKit
import MessageUI
struct IntervaloResultado {
    let entrada: String
    let salida: String
    let horas: Int
    let minutos: Int
    let segundos: Int
    let totalHoras: Double
}
@available(iOS 15.0, *)
class ExcelSearchViewController: UIViewController, qrReaderProtocol, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    private var resultados: [IntervaloResultado] = []
    @IBOutlet weak var table: UITableView!
    var loadin = LoadingView()
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var shareButton: UIButton!
    var devices = [movimiento]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadin)
        search.delegate = self
        table.register(UINib(nibName: "ProductoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openCamara(_ sender: UIButton) {
        let vc = QrReaderViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text!.isEmpty { return }
        getObjects(data: searchBar.text!)
    }
    
    func getObjects(data : String)
    {
        loadin.showLoadingView()
        requestPetition(ofType: Historial.self, typeRequest: .GET, url: "https://avsinventoryswagger25.azurewebsites.net/api/v1/movimientos/filter",header: data) { (httpcode, dataResponse) in
            DispatchQueue.main.async {
                self.loadin.hideLoadingView()
                self.devices.removeAll()
                if httpcode == 200
                {
                    
                    if dataResponse?.data?.count ?? 0 > 0
                    {
                        self.devices = dataResponse?.data ?? []
                        self.devices = ExcelSearchViewController.filtrarRegistrosDuplicados(self.devices)
                        self.calcularIntervalos()
                    }
                    else
                    {
                        self.alerta(message: "No se encontraron resultados")
                    }
                }
                else
                {
                    self.alerta(message: dataResponse?.message?.first?.status ?? "Error en el servicio")
                }
                self.table.reloadData()
            }
        }
    }
    @IBAction func exportAction(_ sender: UIButton) {
        if devices.count > 0
        {
            let actionSheet = UIAlertController(title: "Exportar Datos",
                                                message: "Seleccione una opción",
                                                preferredStyle: .actionSheet)
            
            //               // Guardar en archivo
            //               actionSheet.addAction(UIAlertAction(title: "Guardar en Archivo", style: .default) { _ in
            //                   self.saveToFile()
            //               })
            
            // Compartir por correo
            if MFMailComposeViewController.canSendMail() {
                actionSheet.addAction(UIAlertAction(title: "Enviar por Correo", style: .default) { _ in
                    self.sendEmail()
                })
            }
            
            // Compartir con UIActivityViewController
            actionSheet.addAction(UIAlertAction(title: "Compartir", style: .default) { _ in
                self.shareFile()
            })
            
            actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            
            present(actionSheet, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductoTableViewCell
        
        cell.marca.text = devices[indexPath.row].nombre
        cell.modelo.text = devices[indexPath.row].fechaAlta?.setDateProperly()
        cell.nombre.text = devices[indexPath.row].producto
        cell.lugar.text = devices[indexPath.row].lugar
        
        cell.backgroundColor = .clear
        if devices[indexPath.row].tipo == "Salida"
        {
            cell.marca.textColor = .red
            cell.modelo.textColor = .red
            cell.nombre.textColor = .red
            cell.lugar.textColor = .red
        }
        else
        {
            cell.marca.textColor = .white
            cell.modelo.textColor = .white
            cell.nombre.textColor = .white
            cell.lugar.textColor = .white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func qrReadit(qr: String) {
        search.text = qr
        search.delegate?.searchBar?(search, textDidChange: qr)
    }
    
    private func calcularIntervalos() {
        // Ordenar registros por fecha
        
        var i = 0
        while i < devices.count {
            let registro = devices[i]
            
            if registro.tipo == "Entrada" && i + 1 < devices.count {
                let siguienteRegistro = devices[i + 1]
                
                if siguienteRegistro.tipo == "Salida" {
                    if let entradaDate = registro.fechaAlta?.setDateProperly().toDate(),
                       let salidaDate = siguienteRegistro.fechaAlta?.setDateProperly().toDate() {
                        
                        let intervalo = salidaDate.timeIntervalSince(entradaDate)
                        let horas = Int(intervalo) / 3600
                        let minutos = (Int(intervalo) % 3600) / 60
                        let segundos = Int(intervalo) % 60
                        let totalHoras = intervalo / 3600
                        
                        let resultado = IntervaloResultado(
                            entrada: registro.fechaAlta?.setDateProperly() ?? "",
                            salida: siguienteRegistro.fechaAlta?.setDateProperly() ?? "",
                            horas: horas,
                            minutos: minutos,
                            segundos: segundos,
                            totalHoras: totalHoras
                        )
                        
                        resultados.append(resultado)
                        i += 2 // Avanzamos dos posiciones
                        continue
                    }
                }
            }
            
            i += 1 // Avanzamos una posición si no encontramos pareja
        }
        
        for x in resultados {
            debugPrint(x.entrada, x.totalHoras)
        }
    }
    
    static func filtrarRegistrosDuplicados(_ registros: [movimiento]) -> [movimiento] {
        var registrosFiltrados = [movimiento]()
       
        var i = 0
        let n = registros.count
        
        while i < n {
            let registroActual = registros[i]
            
            // Si es una salida, verificar si hay más salidas consecutivas
            if registroActual.tipo == "Salida" {
                var ultimaSalidaIndex = i
                
                // Buscar la última salida consecutiva
                for j in i+1..<n {
                    if registros[j].tipo == "Salida" {
                        ultimaSalidaIndex = j
                    } else {
                        break
                    }
                }
                
                // Si encontramos salidas consecutivas
                if ultimaSalidaIndex > i {
                    // Agregar solo la última salida del grupo
                    registrosFiltrados.append(registros[ultimaSalidaIndex])
                    i = ultimaSalidaIndex + 1 // Saltar al siguiente registro después del grupo
                    continue
                }
            }
            
            // Agregar registro actual si no es parte de un grupo de salidas
            registrosFiltrados.append(registroActual)
            i += 1
        }
        return registrosFiltrados
    }
    
    @available(iOS 15.0, *)
    private func saveToFile() {
           let csvString = generateCSV()
           let fileName = "intervalos_\(Date().formatted(date: .numeric, time: .omitted)).csv"
           
           do {
               let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: false)
               let fileURL = documentDirectory.appendingPathComponent(fileName)
               
               try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
               
               let alert = UIAlertController(title: "Éxito",
                                           message: "Archivo guardado en: \(fileURL.path)",
                                           preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               present(alert, animated: true)
           } catch {
               showErrorAlert(message: "Error al guardar el archivo: \(error.localizedDescription)")
           }
       }
    @available(iOS 15.0, *)
    private func sendEmail() {
            let csvString = generateCSV()
            guard let csvData = csvString.data(using: .utf8) else {
                showErrorAlert(message: "Error al generar datos CSV")
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Registro de Intervalos")
            mailComposer.setMessageBody("Adjunto encontrarás el registro de intervalos en formato CSV.", isHTML: false)
            
            mailComposer.addAttachmentData(csvData,
                                         mimeType: "text/csv",
                                         fileName: "intervalos.csv")
            
            present(mailComposer, animated: true)
        }
    @available(iOS 15.0, *)
    private func shareFile() {
           let csvString = generateCSV()
           guard let csvData = csvString.data(using: .utf8) else {
               showErrorAlert(message: "Error al generar datos CSV")
               return
           }
        FileManager.default.clearTmpDirectory()
           let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("intervalos\(search.text ?? "").csv")
           
           do {
               try csvData.write(to: fileURL)
               let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
               
               // Configurar para iPad
               if let popover = activityVC.popoverPresentationController {
                   popover.sourceView = shareButton
                   popover.sourceRect = shareButton.bounds
               }
               
               present(activityVC, animated: true)
           } catch {
               showErrorAlert(message: "Error al crear archivo temporal: \(error.localizedDescription)")
           }
       }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                                 didFinishWith result: MFMailComposeResult,
                                 error: Error?) {
            controller.dismiss(animated: true)
            
            if let error = error {
                showErrorAlert(message: "Error al enviar correo: \(error.localizedDescription)")
            }
        }
        
        // MARK: - Helpers
        private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Error",
                                         message: message,
                                         preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
   
}

extension FileManager
{
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach { file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try FileManager.default.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

@available(iOS 15.0, *)
extension ExcelSearchViewController {
    private func generateCSV() -> String {
        // Encabezados del CSV
        var csvString = "N° Registro,Título,Entrada,Salida,Total de días\n"
        var total = 0
        // Contador para número de registro
        var registroNumber = 1
        
        for resultado in resultados {
            // Calcular días entre fechas
            let diasEntreFechas = calculateDaysBetweenDates(startDateString: resultado.entrada,
                                                          endDateString: resultado.salida)
            let salida = devices.first(where: { $0.fechaAlta?.setDateProperly() == resultado.salida.setDateProperly() && $0.tipo == "Salida"})?.lugar ?? "N/A"
            // Calcular total días con decimales
            let totalDias = resultado.totalHoras / 24.0
            
            // Crear fila CSV
            let row = """
            \(registroNumber),Lugar: \(salida),\
            \(formatDateString(resultado.entrada)),\
            \(formatDateString(resultado.salida)),\
            \(diasEntreFechas * -1)\n
            """
            total = total + Int(totalDias)
            csvString.append(row)
            registroNumber += 1
        }
        
        let totalString = "\nTotal: \(total * -1) dias\n"
        csvString.append(totalString)
        return csvString
    }
    
    private func calculateDaysBetweenDates(startDateString: String, endDateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day ?? 0
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
    
    // Actualizar la función de exportación para usar el nuevo CSV
    @objc private func exportEnhancedData() {
        let csvString = generateCSV()
        let fileName = "intervalos_detallados_\(Date().formatted(date: .numeric, time: .omitted)).csv"
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                              in: .userDomainMask,
                                                              appropriateFor: nil,
                                                              create: false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // Mostrar opciones para compartir
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            
            // Configurar para iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = shareButton
                popover.sourceRect = shareButton.bounds
            }
            
            present(activityVC, animated: true)
            
        } catch {
            showErrorAlert(message: "Error al guardar el archivo: \(error.localizedDescription)")
        }
    }
}
