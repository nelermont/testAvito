//
//  ImageCollectionViewCell.swift
//  UIcollectionViewTest
//
//  Created by Дмитрий Подольский on 13.01.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelDes: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
