import UIKit
import Parse

//Mark: Menu delegate
protocol FeedBackDelegate {
    
    //mark: This function will retrun feedback text in order
    func submitFeedback(feedbackText: String)
}
//End Mark

class FeedbackController: NSObject {
    
    //Mark: public delegate variable
    public var delegate: FeedBackDelegate?
    private var currentFeedback = 0
    
    private lazy var feedback: UIView = {
        let viewmenu = UIView()
        viewmenu.backgroundColor = UIColor(red:0.13, green:0.11, blue:0.18, alpha:0.7)
        viewmenu.isUserInteractionEnabled = true
        //viewmenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(feedbackDissmiss)))
        return viewmenu
    }()
    
    private lazy var whiteBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var close: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "closeIconBlack")
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(self.feedbackDissmiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var emoji: UIImageView = {
        let imageview = UIImageView()
        let icon = UIImage(named: "normal")
        imageview.image = icon
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    fileprivate lazy var feeblabel: UILabel = {
        let label = UILabel()
        label.text = "Rate Us"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(RatingCell.self, forCellWithReuseIdentifier: "cell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.allowsMultipleSelection = true
      
        return collection
    }()
    
    private lazy var send: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red:0.04, green:0.72, blue:1.00, alpha:1.0)
        button.addTarget(self, action: #selector(self.submitBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    
    //End Mark
    
    override init() {
        super.init()
    }
    
    //Mark: Present all visual object for the feed back alert
    @objc public func presetFeebBackController() {
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(self.feedback)
            self.feedback.frame = window.bounds
            self.feedback.alpha = 0
            
            self.feedback.insertSubview(self.whiteBackground, at: 0)
            self.whiteBackground.frame = CGRect(x: 35, y: 150, width: window.frame.size.width - 70, height: 270)
            
            self.whiteBackground.addSubview(self.close)
            self.close.topAnchor.constraint(equalTo: self.whiteBackground.topAnchor, constant: 10).isActive = true
            self.close.rightAnchor.constraint(equalTo: self.whiteBackground.rightAnchor, constant: -10).isActive = true
            self.close.widthAnchor.constraint(equalToConstant: 20).isActive = true
            self.close.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            self.whiteBackground.addSubview(self.emoji)
            self.emoji.topAnchor.constraint(equalTo: self.whiteBackground.topAnchor, constant: 10).isActive = true
            self.emoji.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.emoji.widthAnchor.constraint(equalToConstant: 100).isActive = true
            self.emoji.centerXAnchor.constraint(equalTo: self.whiteBackground.centerXAnchor).isActive = true
            
            self.whiteBackground.addSubview(self.feeblabel)
            self.feeblabel.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 10).isActive = true
            self.feeblabel.leftAnchor.constraint(equalTo: self.whiteBackground.leftAnchor).isActive = true
            self.feeblabel.rightAnchor.constraint(equalTo: self.whiteBackground.rightAnchor).isActive = true
            self.feeblabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            self.whiteBackground.addSubview(self.startCollection)
            self.startCollection.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.startCollection.leftAnchor.constraint(equalTo: self.whiteBackground.leftAnchor).isActive = true
            self.startCollection.rightAnchor.constraint(equalTo: self.whiteBackground.rightAnchor).isActive = true
            self.startCollection.bottomAnchor.constraint(equalTo: self.whiteBackground.bottomAnchor, constant: -50).isActive = true
            
            self.whiteBackground.addSubview(self.send)
            self.send.topAnchor.constraint(equalTo: self.startCollection.bottomAnchor).isActive = true
            self.send.rightAnchor.constraint(equalTo: self.whiteBackground.rightAnchor).isActive = true
            self.send.bottomAnchor.constraint(equalTo: self.whiteBackground.bottomAnchor).isActive = true
            self.send.leftAnchor.constraint(equalTo: self.whiteBackground.leftAnchor).isActive = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.feedback.alpha = 1
            })
            
        }
    }
    //End Mark
    
    //Mark: feedback element turn hides
    @objc fileprivate func feedbackDissmiss() {
        self.startCollection.reloadData()
        if self.currentFeedback == 4 {
            let id = "1291132506"
            let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(id)?mt=8&action=write-review")
            UIApplication.shared.open(url!, options: ["": ""], completionHandler: nil)
        }
        UIView.animate(withDuration: 0.5) {
            self.feedback.alpha = 0
        }
 
    }
    //End Mark
    
    //Makr: when submit element is press it will send the data to throght the delegate
    @objc fileprivate func submitBtn() {
        guard let currentUser = PFUser.current() else {return}
        let query = PFObject(className: "Feedback")
        query["feedback"] = "\(self.currentFeedback + 1)"
        query["User"] = currentUser
        query.saveEventually { (success, error) in
            if error == nil {
                self.feedbackDissmiss()
            }
        }
      
    }
    //End Mark
    
    private func changeEmji(index: Int) {
        var icon = UIImage()
        switch index {
        case 0:
            icon = UIImage(named: "surprice")!
        case 1:
            icon = UIImage(named: "nervious")!
        case 2:
            icon = UIImage(named: "smile")!
        case 3:
            icon = UIImage(named: "funny")!
        case 4:
            icon = UIImage(named: "best")!
            
        default:
            break
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.emoji.image = icon
        }, completion: nil)
    }
}

extension FeedbackController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(5)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 0.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
 
}

extension FeedbackController: UICollectionViewDelegate {
    
}

extension FeedbackController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RatingCell else {
            return UICollectionViewCell()
        }
        cell.StartImage.image =  UIImage.init(icon: .FAStar, size: CGSize(width: 50, height: 50), orientation: UIImageOrientation.up, textColor: .black, backgroundColor: .clear)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentFeedback = indexPath.item
        self.changeEmji(index: currentFeedback)
        for x in (0...indexPath.item).reversed() {
            let path = IndexPath(item: x, section: 0)
            guard let cell = collectionView.cellForItem(at: path) as? RatingCell else {return}
            cell.StartImage.image = UIImage.init(icon: .FAStar, size: CGSize(width: 50, height: 50), orientation: UIImageOrientation.up, textColor: UIColor(red:0.88, green:0.37, blue:0.37, alpha: 1.0), backgroundColor: .clear)
        }
        
        
        for x in (indexPath.item ... 4) {
            let path = IndexPath(item: x + 1, section: 0)
            guard let cell = collectionView.cellForItem(at: path) as? RatingCell else {return}
            cell.StartImage.image = UIImage.init(icon: .FAStar, size: CGSize(width: 50, height: 50), orientation: UIImageOrientation.up, textColor: .black, backgroundColor: .clear)
        }
        
    }

}

class RatingCell: UICollectionViewCell {
    
    public lazy var StartImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(icon: .FAStar, size: CGSize(width: 50, height: 50), orientation: UIImageOrientation.up, textColor: .gray, backgroundColor: .black)
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(self.StartImage)
        self.StartImage.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
}



