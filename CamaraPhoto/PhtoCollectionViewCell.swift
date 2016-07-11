//
//  PhtoCollectionViewCell.swift
//  CamaraPhoto
//
//  Created by Kyle on 7/10/16.
//  Copyright © 2016 Alphacamp. All rights reserved.
//

import UIKit

class PhtoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PotoImageView: UIImageView!
    @IBOutlet weak var phptoDate: UILabel!
    
    override func prepareForReuse() {
        PotoImageView.image = nil
    }

}
