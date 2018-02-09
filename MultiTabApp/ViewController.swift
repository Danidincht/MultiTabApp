//
//  ViewController.swift
//  MultiTabApp
//
//  Created by Pedro Herrera on 13/01/2018.
//  Copyright © 2018 Pedro Herrera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var data: [Electrodomestico] = []
    var selectedRow: Int = 0
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadBar: UIActivityIndicatorView!
    @IBOutlet weak var eliminarBt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leerDatos()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellName)
        
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellName)
            
        }
        
        let text = data[indexPath.section].descripcion
        
        cell?.textLabel?.text = text
        cell?.detailTextLabel?.text = String(data[indexPath.section].precio)
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        var elec = data[indexPath[0]]
        selectedRow = elec.id
    }
    
    @IBAction func eliminar(_ sender: Any) {
        borrarDatos()
        print("ID A BORRAR: \(selectedRow)")
    }
    
    func borrarDatos()
    {
        self.data = []
        self.loadBar.isHidden = false
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.144:880/www/deleteRow.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "ID=\(selectedRow)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
        }
        DispatchQueue.main.async{ self.leerDatos() }
        task.resume()
    }
    
    func leerDatos()
    {
        print("Reading data")
        self.data = []
        self.loadBar.isHidden = false

        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.144:880/www/getData.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = ""
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            self.parseJSON(data!)  //Descomentar para volver a coger datos de la web
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadBar.isHidden = true
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data)
    {
        var json = NSArray()
        
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError { print(error) }
        
        var jsonElement = NSDictionary()
        
        for i in 0..<json.count
        {
            jsonElement = json[i] as! NSDictionary
            
            let electro = Electrodomestico()
        
            let idElectro = jsonElement.object(forKey: "ID") as! String
            print("ID: \(idElectro)")
            let text1 = jsonElement.object(forKey: "DESCRIPCION") as! String
            let text2 = jsonElement.object(forKey: "PRECIO") as! String
            
            electro.id = Int(idElectro)!
            electro.descripcion = text1
            electro.precio = Int(text2)!
            self.data.append(electro)
        }
        
    }


}

