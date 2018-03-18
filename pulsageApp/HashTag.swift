import UIKit
import Parse

class HashTag: UIViewController {
    
    public var hashTagString = ""
    private var dataHolder = [PFObject]()
    private let collectionid = "id"
    
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
        let coll = UICollectionView(frame: cframe, collectionViewLayout: layout)
        coll.register(SearchSQCell.self, forCellWithReuseIdentifier: self.collectionid)
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.translatesAutoresizingMaskIntoConstraints = false
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addsubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        
    }
    
    //Mark: Get Hashtag data
    private func getHashtagData(hashtag: String) -> PFObject? {
        let query = PFQuery(className: "hashtag")
        query.whereKey("tittle", equalTo: hashtag)
        do {
            let result = try query.getFirstObject()
            return result
        } catch {
            print(error)
            return nil
        }
        
    }
    
    private func gethashtag() {
        guard let hash = self.getHashtagData(hashtag: self.hashTagString) else {return}
        let query = PFQuery(className: "Videos")
        query.whereKey("", equalTo: hash)
        query.findObjectsInBackground { (result, error) in
            if error == nil {
                guard let data = result else {return}
                print(data)
            }
        }
    }
    
    //Mark: Set Visual Objects into view
    private func addsubviews() {
        self.view.addSubview(self.collection)
        self.collection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collection.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collection.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.collection.addSubview(self.followBtn)
        self.followBtn.topAnchor.constraint(equalTo: self.collection.topAnchor).isActive = true
        self.followBtn.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.followBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.followBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        guard let PFfile = row["thumbnial"] as? PFFile else {return UICollectionViewCell()}
        guard let fileurl = PFfile.url else {return UICollectionViewCell()}
        guard let url = URL(string: fileurl) else {return UICollectionViewCell()}
        collectionCell.Thumbnail.sd_setImage(with: url, completed: nil)
        return collectionCell
    }
    
    
}


