import UIKit
import Parse

class HashTag: UIViewController {
    
    public var hashTagString = ""
    private var dataHolder: [PFObject] = []
    fileprivate let collectionid = "id"
    
    private lazy var followBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let halfWith = self.view.frame.size.width / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: halfWith - 1, height: halfWith - 2)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let cframe = CGRect(x: 0, y: 0, width: 0, height: 0)
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        coll.register(SearchSQCell.self, forCellWithReuseIdentifier: self.collectionid)
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.translatesAutoresizingMaskIntoConstraints = false
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addsubviews()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.gethashtag()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.hashTagString = ""
    }
    
    //Mark: Get Hashtag data
    private func getHashtagData(hashtag: String) -> String {
        let query = PFQuery(className: "hashtag")
        query.whereKey("tittle", equalTo: hashtag)
        do {
            let result = try query.getFirstObject()
            
            guard let id = result.objectId else {return String()}
            return id
        } catch {
            return "nto data"
        }
        
    }
    
    private func gethashtag() {
        self.dataHolder.removeAll()
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
        
        
        let hash = self.getHashtagData(hashtag: self.hashTagString)
        let query = PFQuery(className: "Videos")
        query.whereKey("hashtags", equalTo: hash)
        query.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let data = result else {return}
                self.dataHolder = data
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            
            } else {
                print("no daya")
            }
        }
    }
    
    //Mark: Set Visual Objects into view
    private func addsubviews() {
        
        self.view.addSubview(self.followBtn)
        self.followBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.followBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.followBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.followBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(self.collection)
        self.collection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        self.collection.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collection.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
    }
}

extension HashTag: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionid, for: indexPath) as? SearchSQCell else {
            return  UICollectionViewCell()
        }
        
        let row = self.dataHolder[indexPath.row]
        guard let PFfile = row["thumbnail"] as? PFFile else {return UICollectionViewCell()}
        guard let fileurl = PFfile.url else {return UICollectionViewCell()}
        guard let url = URL(string: fileurl) else {return UICollectionViewCell()}
        collectionCell.Thumbnail.sd_setImage(with: url, completed: nil)
        return collectionCell
    }
    
    
}


