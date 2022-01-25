//
//  SSHistoricoViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 1/22/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class SSHistoricoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth = UserDefaults.standard.integer(forKey: "autenticado")
        
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 4.0, execute: {
            if(auth==1){
                self.performSegue(withIdentifier:"iniciadoSegue",sender: self)
            }else{
                self.performSegue(withIdentifier:"inicio2Segue",sender: self)
            }
        })
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
