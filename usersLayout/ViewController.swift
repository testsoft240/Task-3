//
//  ViewController.swift
//  usersLayout
//
//  Created by MAC240 on 06/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tblView: UITableView!
    var modelgetuserData = modelusersData()
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var limit:Int = 5
    var offset:Int = 0
    var isDataLoading:Bool = false
    
    var index = Int()
    
    var userdata = [userData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = activityIndicator
        getUserData()
    }

    
    //MARK: Api calling
    func getUserData(){
        var dictParameters = [String : String]()
        dictParameters = ["offset": "0", "limit": "\(limit)"]
        let strUrl = "http://sd2-hiring.herokuapp.com/api/users"
        
        AF.request(strUrl, method: .get, parameters: dictParameters, encoding: Alamofire.URLEncoding.default).responseJSON
        { [self](response) in
            
            let data = response.value as? [String: Any]
           
            var aDictResponseData = [String:Any]()
            aDictResponseData = data?["data"] as! [String:Any]
            self.modelgetuserData = modelusersData(dictionary: aDictResponseData)
            print("response is \(aDictResponseData)")
        
            let one = userData(image: self.modelgetuserData.users[0].name, items: self.modelgetuserData.users[0].items ?? [])
            let two = userData(image: self.modelgetuserData.users[1].name, items: self.modelgetuserData.users[1].items ?? [])
            let three = userData(image: self.modelgetuserData.users[2].name, items: self.modelgetuserData.users[2].items ?? [])
            let four = userData(image: self.modelgetuserData.users[3].name, items: self.modelgetuserData.users[3].items ?? [])
            
            userdata.append(one)
            userdata.append(two)
            userdata.append(three)
            userdata.append(four)
            
            print("userdata array \(userdata)")
            
            self.tblView.reloadData()
        }
    }
    
    
    
    //MARK: Tableview datasource delegate method

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelgetuserData.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myCell
        
        cell.userName.text = modelgetuserData.users[indexPath.row].name
        
        
        
        let imgUrl = URL(string: modelgetuserData.users[indexPath.row].image ?? "")
//                cell.userImg.sd_setImage(with: imgUrl)
        //        cell.userImg.load(urlString: "http://loremflickr.com/300/300?random=1")
//        do {
//         var url = URL(string: "https://loremflickr.com/320/240?random=1")
//            let data = try Data(contentsOf: url!)
//            cell.userImg.image = UIImage(data: data)
//        }
//        catch{
//            print(error.localizedDescription)
//        }
        
        cell.userImg.sd_setImage(with: URL(string:"https://picsum.photos/seed/picsum/200/300")) { (img, error, cache, url) in
            if let error = error{
                print("error is \(error)")
            }
        }
        
        cell.frame = tblView.bounds
        cell.collectionview.tag = indexPath.row
        cell.collectionview.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let preferencesCell = cell as? myCell else { return }
        
//        let tag = Int("\(indexPath.section)\(indexPath.row)")!
        
        preferencesCell.setCollectionView(dataSourceDelegate: self)
        
        preferencesCell.collectionview.setNeedsLayout()
        preferencesCell.layoutIfNeeded()
        preferencesCell.const_cvPreferences_height.constant = preferencesCell.collectionview.contentSize.height
        preferencesCell.collectionview.setNeedsLayout()
        preferencesCell.layoutIfNeeded()
        preferencesCell.contentView.layoutIfNeeded()
        preferencesCell.collectionview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- pagination methods

    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tblView.contentOffset.y + tblView.frame.size.height) >= tblView.contentSize.height)
        {
            if !isDataLoading{
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                
                if modelgetuserData.has_more == false{
                    self.tblView.tableFooterView?.isHidden = true
                }else{
                    self.limit += 5
                    getUserData()
                }
            }
        }
    }
}


//MARK:- collection view data source methods

extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelgetuserData.users[collectionView.tag].items?.count ?? 0
    }

  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! mycollectionCell
        
        cell.itemImgView.sd_setImage(with: URL(string:"https://picsum.photos/seed/picsum/200/300"))
        cell.itemImgView.contentMode = .scaleAspectFill
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.numberOfItems(inSection: 0) % 2 != 0 && indexPath.row == 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
            
        }
        return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.width - 5) / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

//MARK:- uitableviewCell

class myCell : UITableViewCell{
    
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
        return UINib(nibName: "mycollectionCell", bundle: nil)
    }
    
}

//MARK:- uicollectionviewCell
class mycollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var itemImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
}


//MARK:- ImageView Extension
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

struct userData{
    public var image : String?
    public var items : [String]
}
