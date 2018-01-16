import UIKit
import Parse

class search: UIViewController {
    
    //fileprivate variables
    fileprivate var filterHolder = [PFObject]()
    fileprivate let collectionid = "cellId"
    //============================
    
    //Mark: fileprivate visual objects
    fileprivate lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search"
        searchbar.searchBarStyle = .prominent
        searchbar.delegate = self
        searchbar.sizeToFit()
        searchbar.barTintColor = UIColor(red:0.85, green:0.34, blue:0.33, alpha:1.0)
        searchbar.tintColor = .white
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let halfWith = self.view.frame.size.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: halfWith, height: halfWith)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cframe = CGRect(x: 0, y: 0, width: 0, height: 0)
        let coll = UICollectionView(frame: cframe, collectionViewLayout: layout)
        coll.register(SearchSQCell.self, forCellWithReuseIdentifier: self.collectionid)
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.translatesAutoresizingMaskIntoConstraints = false
        return coll
    }()
    //============================
    
    //Mark: UIVireController Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addsubviews()
        self.getBestVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
    }
    
    //=====================================================
    
    private func addsubviews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.searchBar)
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -46).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(self.collection)
        self.collection.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.collection.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collection.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func getBestVideo() {
        PFCloud.callFunction(inBackground: "searchTabVideos", withParameters: ["":""], block: { (videos, error) in
            guard let videosData = videos as? [PFObject] else {return}
            self.filterHolder = videosData
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
            
        })
    }
}

extension search: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let query = PFQuery(className: "Videos")
            query.whereKey("name", contains: searchText)
            query.whereKey("block", notEqualTo: true)
            query.findObjectsInBackground { (results, error) in
                guard let result = results else {return}
                self.filterHolder = result
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
        } else {
            self.filterHolder = [PFObject]()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        self.getBestVideo()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
}

extension search: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collecCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionid, for: indexPath) as? SearchSQCell else {
            return UICollectionViewCell()
        }
        //Mark: Object for each row
        let objectForRow = self.filterHolder[indexPath.row]
        guard let thumbFile = objectForRow["thumbnail"] as? PFFile else {return UICollectionViewCell()}
        guard let thumbFileUrl = thumbFile.url else {return UICollectionViewCell()}
        guard let thumbnailUrl = URL(string: thumbFileUrl) else {return UICollectionViewCell()}
        collecCell.Thumbnail.sd_setImage(with: thumbnailUrl)
        return collecCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoPlayer = VideoPlayer()
        videoPlayer.videdata = self.filterHolder[indexPath.row]
        self.navigationController?.pushViewController(videoPlayer, animated: true)
    }
    
}

/*
class search: UIViewController {
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
 
    
 
    
    fileprivate lazy var searchTable: UITableView = {
        let table = UITableView()
            table.frame = CGRect(x: 0, y: 107, width: self.view.frame.size.width, height: self.view.frame.size.height - 98)
            table.delegate = self
            table.dataSource = self
            table.register(VideosCell.self, forCellReuseIdentifier: "id")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.SubViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func SubViews() {
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchTable)
    }

}



extension search: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as? VideosCell
        let video = self.filtered[indexPath.row]
        let pffile = video["thumbnail"] as! PFFile //get image and put as pffile
        let url = URL(string: pffile.url!) //string url to url class
        let description = video["description"] as! String
        
        cell?.titleText = video["name"] as! String
        cell?.videos.sd_setImage(with: url)
        cell?.viewText = description
        cell?.postedbyText = ""
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoPlayer = VideoPlayer()
        let section = self.filtered[indexPath.section]
        
       // let row = section[indexPath.row]
        guard let videourl = section["video"] as? PFFile else {return}
        guard let title = section["name"] as? String else {return}
        guard let objectid = section.objectId else {return}
        guard let created = section.createdAt  else {return}
        
        
        //videoPlayer.getRealetedVideos = self.filtered[indexPath.section]
        videoPlayer.videdata = section
        
        self.present(videoPlayer, animated: true, completion: nil)
    }
}
*/
