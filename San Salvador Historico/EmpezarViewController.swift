//
//  EmpezarViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/19/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class EmpezarViewController: UIViewController {

    @IBOutlet weak var lbl02: UILabel!
    @IBOutlet weak var lbl03: UILabel!
    @IBOutlet weak var btnEmpezar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lbl02.text="Looking for new beginning?"
            lbl03.text="Navigate through the past and present, and begin the future you want"
            btnEmpezar.setTitle("Start", for: .normal)
        }
        // Do any additional setup after loading the view.
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
