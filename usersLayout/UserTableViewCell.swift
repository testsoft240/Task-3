//
//  userTableViewCell.swift
//  usersLayout
//
//  Created by MAC240 on 12/10/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var const_cvPreferences_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImg.layer.cornerRadius = 28
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCollectionView(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        self.collectionview.delegate = dataSourceDelegate
        self.collectionview.dataSource = dataSourceDelegate
        self.collectionview.reloadData()
    }
    class func Nib() -> UINib {
        return UINib(nibName: "userCollectionViewCell", bundle: nil)
    }

}
