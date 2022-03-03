//
//  MenuViewController.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 26/01/22.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var items = [MenuItem]()
    @IBOutlet weak var MenuCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuCollection.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        items = MenuItems.MenuAdmin
        MenuCollection.backgroundColor = .clear
        MenuCollection.reloadData()
        self.navigationItem.title = ""
        setNavigationBar()
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            UsuarioData.deleteUser()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if items.count % 2 == 0
        {
            return items.count/2
        }
        else
        {
            return (items.count + 1)/2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.items.count % 2 == 0
        {
            return 2
        }
        else
        {
            if section == (self.items.count + 1)/2 - 1
            {
                return 1
            }
            else {
                return 2
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cont = 0
        var numero = 0
        if self.items.count % 2 == 0
        {
            numero = Int(self.items.count/2)
        }
        else
        {
            numero = (self.items.count + 1)/2
        }
        for x in 0..<numero
        {
            if indexPath.section == x
            {
                let vc = UIStoryboard(name: items[indexPath.row +  cont].storyboard, bundle: nil).instantiateViewController(withIdentifier: items[indexPath.row + cont].route)
                self.navigationController?.pushViewController(vc, animated: true)
                print(items[indexPath.row + cont].storyboard, items[indexPath.row + cont].route)
            }
            cont = cont + 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCollectionViewCell
        var cont = 0
        var numero = 0
        if self.items.count % 2 == 0
        {
            numero = Int(self.items.count/2)
        }
        else
        {
            numero = (self.items.count + 1)/2
        }
        for x in 0..<numero
        {
            if indexPath.section == x
            {
                if let m = UIImage(named: items[indexPath.row + cont].imagen)
                {
                    let im = resizeImage(image: m, targetSize: CGSize(width: MenuCollection.frame.width/2 - 10, height: MenuCollection.frame.height/3 - 10))
                
                print(indexPath.row, cont, m,im)
                cell.imagen.image = im
                }
            }
            cont = cont + 2

        }
        cell.backgroundColor = .clear
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MenuCollection.frame.width/2 - 5, height: MenuCollection.frame.height/3 - 5)
    }
    
    
}
