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
    let colorOff = UIColor(red: 8/255, green: 8/255, blue: 70/255, alpha: 1)
    let colorOn = UIColor(red: 47/255, green: 178/255, blue: 255/255, alpha: 1)
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
            ModeloSwitch.thumbTintColor = colorOff
            marcaSwitch.thumbTintColor = colorOff
            CodigoSwitch.thumbTintColor = colorOff
            SerieSwitch.thumbTintColor = colorOff
            break
        case .modelo:
                nombreSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
                ModeloSwitch.setOn(true, animated: true)
            nombreSwitch.thumbTintColor = colorOff
            marcaSwitch.thumbTintColor = colorOff
            CodigoSwitch.thumbTintColor = colorOff
            SerieSwitch.thumbTintColor = colorOff
            break
        case .marca:
                ModeloSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(true, animated: true)
            ModeloSwitch.thumbTintColor = colorOff
            nombreSwitch.thumbTintColor = colorOff
            CodigoSwitch.thumbTintColor = colorOff
            SerieSwitch.thumbTintColor = colorOff
            break
        case .codigo:
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
                SerieSwitch.setOn(false, animated: true)
            CodigoSwitch.setOn(true, animated: true)
            ModeloSwitch.thumbTintColor = colorOff
            marcaSwitch.thumbTintColor = colorOff
            nombreSwitch.thumbTintColor = colorOff
            SerieSwitch.thumbTintColor = colorOff
            break
        case .serie:
            SerieSwitch.setOn(true, animated: true)
                ModeloSwitch.setOn(false, animated: true)
                marcaSwitch.setOn(false, animated: true)
                CodigoSwitch.setOn(false, animated: true)
                nombreSwitch.setOn(false, animated: true)
            ModeloSwitch.thumbTintColor = colorOff
            marcaSwitch.thumbTintColor = colorOff
            CodigoSwitch.thumbTintColor = colorOff
            nombreSwitch.thumbTintColor = colorOff
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
                ModeloSwitch.thumbTintColor = colorOff
                marcaSwitch.thumbTintColor = colorOff
                SerieSwitch.thumbTintColor = colorOff
                CodigoSwitch.thumbTintColor = colorOff
                nombreSwitch.thumbTintColor = colorOn
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
                ModeloSwitch.thumbTintColor = colorOn
                marcaSwitch.thumbTintColor = colorOff
                SerieSwitch.thumbTintColor = colorOff
                CodigoSwitch.thumbTintColor = colorOff
                nombreSwitch.thumbTintColor = colorOff
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
                ModeloSwitch.thumbTintColor = colorOff
                marcaSwitch.thumbTintColor = colorOn
                SerieSwitch.thumbTintColor = colorOff
                CodigoSwitch.thumbTintColor = colorOff
                nombreSwitch.thumbTintColor = colorOff
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
                ModeloSwitch.thumbTintColor = colorOff
                marcaSwitch.thumbTintColor = colorOff
                SerieSwitch.thumbTintColor = colorOff
                CodigoSwitch.thumbTintColor = colorOn
                nombreSwitch.thumbTintColor = colorOff
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
                ModeloSwitch.thumbTintColor = colorOff
                marcaSwitch.thumbTintColor = colorOff
                SerieSwitch.thumbTintColor = colorOn
                CodigoSwitch.thumbTintColor = colorOff
                nombreSwitch.thumbTintColor = colorOff
            }
            break
        default:
            break
        }
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
