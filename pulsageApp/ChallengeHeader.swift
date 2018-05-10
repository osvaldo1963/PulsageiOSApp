import UIKit
import Parse

class ChallengeHeader: UIView {
    
    public var objects = [PFObject]()
    public var delegate: ChallengeHeaderTaped?
    
    private lazy var FirstLabel: UILabel = {
        let label = UILabel()
        label.text = "First"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        return label
    }()
    
    private lazy var BestLabel: UILabel = {
        let label = UILabel()
        label.text = "Best"
        label.font = UIFont.systemFont(ofSize: 19)
        label.textAlignment = .right
        label.textColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        return label
    }()
    
    private lazy var VideoPosition: UIStackView =  {
        let stackview = UIStackView()
        stackview.backgroundColor = .gray
        stackview.alignment = .center
        stackview.spacing = 10
        stackview.distribution = .fillEqually
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private lazy var separator: UIView = {
        let vw = UIView()
        vw.backgroundColor = .gray
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    public lazy var challengeCreatorImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public lazy var creatorProfileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("creatorProfile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var challengeCaption: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.textColor = .black
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    public lazy var instagramProfileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Instagram", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 18
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var pageController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width, height: 230)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let page = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        page.delegate = self
        page.dataSource = self
        page.register(collectionHeaderCell.self, forCellWithReuseIdentifier: "id")
        page.backgroundColor = .white
        page.showsHorizontalScrollIndicator = false
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    
    public lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setSubviewContrains()
    }
    
    private func setSubviewContrains() {
        
        self.addSubview(self.VideoPosition)
        self.VideoPosition.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.VideoPosition.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.VideoPosition.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.VideoPosition.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.VideoPosition.addArrangedSubview(self.BestLabel)
        self.VideoPosition.addArrangedSubview(self.FirstLabel)
        
        self.addSubview(self.separator)
        self.separator.topAnchor.constraint(equalTo: self.VideoPosition.bottomAnchor).isActive = true
        self.separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.separator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.addSubview(self.pageController)
        self.pageController.topAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 10).isActive = true
        self.pageController.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.pageController.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.pageController.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70).isActive = true
        
        self.addSubview(self.challengeCreatorImage)
        self.challengeCreatorImage.topAnchor.constraint(equalTo: self.pageController.bottomAnchor, constant: 5).isActive = true
        self.challengeCreatorImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.challengeCreatorImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.challengeCreatorImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.addSubview(self.creatorProfileBtn)
        self.creatorProfileBtn.topAnchor.constraint(equalTo: self.pageController.bottomAnchor, constant: 3).isActive = true
        self.creatorProfileBtn.leftAnchor.constraint(equalTo: self.challengeCreatorImage.rightAnchor, constant: 10).isActive = true
        self.creatorProfileBtn.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        self.creatorProfileBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(self.challengeCaption)
        self.challengeCaption.topAnchor.constraint(equalTo: self.creatorProfileBtn.bottomAnchor).isActive = true
        self.challengeCaption.leftAnchor.constraint(equalTo: self.challengeCreatorImage.rightAnchor, constant: 5).isActive = true
        self.challengeCaption.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        self.challengeCaption.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        
        /*
        self.addSubview(self.challengeCreatorImage)
        self.challengeCreatorImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.challengeCreatorImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.challengeCreatorImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.challengeCreatorImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.addSubview(self.creatorProfileBtn)
        self.creatorProfileBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.creatorProfileBtn.leftAnchor.constraint(equalTo: self.challengeCreatorImage.rightAnchor, constant: 10).isActive = true
        self.creatorProfileBtn.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        self.creatorProfileBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(self.instagramProfileBtn)
        self.instagramProfileBtn.topAnchor.constraint(equalTo: self.creatorProfileBtn.bottomAnchor, constant: 5).isActive = true
        self.instagramProfileBtn.leftAnchor.constraint(equalTo: self.challengeCreatorImage.rightAnchor, constant: 10).isActive = true
        self.instagramProfileBtn.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        self.instagramProfileBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(self.followBtn)
        self.followBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.followBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.followBtn.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        self.followBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
 
        self.addSubview(self.pageControl)
        self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        self.pageControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.pageControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 8).isActive = true
        self.pageControl.numberOfPages = self.objects.count // Set Number of pages to
        */
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.pageControl.currentPage = currentPage
        if currentPage == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.BestLabel.font = UIFont.systemFont(ofSize: 20)
                self.FirstLabel.font = UIFont.systemFont(ofSize: 14)
            })
        } else if currentPage == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.BestLabel.font = UIFont.systemFont(ofSize: 14)
                self.FirstLabel.font = UIFont.systemFont(ofSize: 20)
            })
        }
    }
    
}

extension ChallengeHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as? collectionHeaderCell else {return UICollectionViewCell()}
        let row = self.objects[indexPath.item]
        guard let videoDesc = row["description"] as? String else {return UICollectionViewCell()}
        guard let file = row["thumbnail"] as? PFFile else {return UICollectionViewCell()}
        guard let picurl = file.url else {return UICollectionViewCell()}
        guard let url = URL(string: picurl) else {return UICollectionViewCell()}
        collection.thumbnail.sd_setImage(with: url)
        collection.videoDescription.text = videoDesc
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = self.objects[indexPath.item]
        self.delegate?.videoSelected(item: video)
    }
    
}

protocol ChallengeHeaderTaped {
    func videoSelected(item: PFObject)
}




