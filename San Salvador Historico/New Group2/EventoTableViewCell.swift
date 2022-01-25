//
//  EventoTableViewCell.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/6/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class EventoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEvento: UILabel!
    @IBOutlet weak var imgEvento: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
