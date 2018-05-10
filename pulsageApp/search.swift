import UIKit
import Parse

class search: PulsageViewController {
    
    //private variables
    private var filterHolder = [PFObject]()
    private let collectionid = "cellId"
    //============================
    
    //Mark: fileprivate visual objects
    fileprivate lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search"
        searchbar.searchBarStyle = .prominent
        searchbar.delegate = self
        searchbar.sizeToFit()
        searchbar.barTintColor = .white
        searchbar.tintColor = .black
        searchbar.layer.backgroundColor = UIColor.clear.cgColor
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let halfWith = self.view.frame.size.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: halfWith - 1, height: halfWith - 2)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.getBestVideo()
        }
        self.view.backgroundColor = UIColor(red:0.85, green:0.34, blue:0.33, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
       
    }
    
    //=====================================================
    
    private func addsubviews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.searchBar)
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
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
        PFCloud.callFunction(inBackground: "getdata", withParameters: ["class":"Videos"], block: { (videos, error) in
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
        self.getBestVideo()
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
