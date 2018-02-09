//
//  SecondViewController.swift
//  MultiTabApp
//
//  Created by Pedro Herrera on 07/02/2018.
//  Copyright © 2018 Pedro Herrera. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var descripcionTf: UITextField!
    @IBOutlet weak var precioTf: UITextField!
    @IBOutlet weak var guardarBt: UIButton!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ha cargardo la segunda")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guardar(_ sender: Any) {
        let desc = descripcionTf.text!
        let precio = precioTf.text!
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.144:880/www/addRow.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "DESCRIPCION=\(desc)&PRECIO=\(precio)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                self.message = "Error 1"
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if((responseString?.isEqual(to: "1")))!
            {
                self.message = "Añadido"
            }
            else
            {
                self.message = "Error al añadir"
            }
            print("responseString=\(responseString)")
        }
        task.resume()
        
        let alert = UIAlertController(title: "Registro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: {_ in
            NSLog("The \"OK\" alert ocurred. ")
        }))
        self.present(alert, animated: true, completion: nil)
        
        print("ffff  \(self.message)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
