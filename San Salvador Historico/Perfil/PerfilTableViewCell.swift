//
//  PerfilTableViewCell.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class PerfilTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMenuPerfil: UIImageView!
    @IBOutlet weak var lblPerfil: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
