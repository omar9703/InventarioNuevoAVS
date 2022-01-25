//
//  FilterViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import UIKit
enum TypeFilter  {
    case nombre
    case modelo
    case marca
    case codigo
    case serie
}

protocol FilterSwitchProtocol {
    func ChangeSwitchFilter(filtro : TypeFilter)
}

class FilterViewController: UIViewController {
    var delegate : FilterSwitchProtocol? = nil
    @IBOutlet weak var nombreSwitch: UISwitch!
    @IBOutlet weak var ModeloSwitch: UISwitch!
    @IBOutlet weak var marcaSwitch: UISwitch!
    @IBOutlet weak var CodigoSwitch: UISwitch!
    @IBOutlet weak var SerieSwitch: UISwitch!
    var tipo = TypeFilter.nombre
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch tipo {
        case .nombre:
            nombreSwitch.setOn(true, animated: true)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            break
        case .modelo:
                nombreSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
                ModeloSwitch.setOn(true, animated: true)
            break
        case .marca:
                ModeloSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            marcaSwitch.setOn(true, animated: true)
            break
        case .codigo:
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            CodigoSwitch.setOn(true, animated: true)
            break
        case .serie:
            SerieSwitch.setOn(true, animated: true)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
            break
        }
    }
    
    @IBAction func SwitchPulse(_ sender: UISwitch) {
        switch sender {
        case nombreSwitch:
            if sender.isOn
            {
                delegate?.ChangeSwitchFilter(filtro: .nombre)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            }
            break
        case ModeloSwitch:
            if sender.isOn
            {
                delegate?.ChangeSwitchFilter(filtro: .modelo)
                nombreSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            }
            break
        case marcaSwitch:
            if sender.isOn
            {
                delegate?.ChangeSwitchFilter(filtro: .marca)
                ModeloSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            }
            break
        case CodigoSwitch:
            if sender.isOn
            {
                delegate?.ChangeSwitchFilter(filtro: .codigo)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            }
            break
        case SerieSwitch:
            if sender.isOn
            {
                delegate?.ChangeSwitchFilter(filtro: .serie)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
            }
            break
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
