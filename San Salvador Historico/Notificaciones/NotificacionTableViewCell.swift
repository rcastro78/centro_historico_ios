//
//  NotificacionTableViewCell.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/11/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class NotificacionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDescrip: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
