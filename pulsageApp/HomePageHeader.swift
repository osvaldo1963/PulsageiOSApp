import UIKit
import Parse

class HomePageHeader: UIView {
    
    public var challengesArray: [PFObject] = []
    
    public var delegate: HomepagehaderDelegate?
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = " Challenges"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionId = "id"
    
    public lazy var headerColletion: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(HomeHeaderCell.self, forCellWithReuseIdentifier: self.collectionId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private lazy var separator: UIView = {
        let sp = UIView()
        sp.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.headerTitle)
        self.headerTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.headerTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.headerTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.headerTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(self.headerColletion)
        self.headerColletion.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.headerColletion.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.headerColletion.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.headerColletion.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1).isActive = true
        
        self.addSubview(self.separator)
        self.separator.topAnchor.constraint(equalTo: self.headerColletion.bottomAnchor).isActive = true
        self.separator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.separator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
}

extension HomePageHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.challengesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionId, for: indexPath) as? HomeHeaderCell else {
            return UICollectionViewCell()
        }
        let Item = self.challengesArray[indexPath.item]
        guard let user = Item["User"] as? PFObject else { return UICollectionViewCell()}
        user.fetchInBackground { (result, error) in
            guard let userData = result else {return}
            guard let picFile =  userData["profilePicture"] as? PFFile else {return}
            guard let picUrl = picFile.url else {return}
            guard let url = URL(string: picUrl) else {return}
            item.thumbnail.sd_setImage(with: url, completed: nil)
            item.challengeTittle.text = userData.handle
            
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.challengeSelected(index: indexPath.item)
    }
    
}

protocol HomepagehaderDelegate {
    func challengeSelected(index: Int)
}

