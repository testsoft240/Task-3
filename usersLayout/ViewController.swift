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
            
            
            self.tblView.reloadData()
        }
    }
    
    
    
    //MARK: Tableview datasource delegate method

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelgetuserData.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
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
        
        guard let preferencesCell = cell as? UserTableViewCell else { return }
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! UserCollectionViewCell
        
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
    
}

