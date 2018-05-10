import UIKit

class Segmented: UIView{
    //Mark: This custom segmented has to explicintly declare the number of tabs
    
    public var ImagesArray = [UIImage]()
    var delegate: SegmentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.subViews(frame: frame)
        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subViews(frame: frame)
    }
    
    fileprivate func subViews(frame: CGRect) {
        let images = self.ImagesArray
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width / CGFloat(images.count), height: frame.size.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionview = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: layout)
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectioncell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .white
        collectionview.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .top)
        collectionview.allowsSelection = true
        collectionview.allowsMultipleSelection = false
        self.addSubview(collectionview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Segmented: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let images = self.ImagesArray
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageview = UIImageView()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath)
        let images = self.ImagesArray 
        cell.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        cell.addSubview(imageview)
        imageview.frame = CGRect(x: cell.frame.size.width / 2 - 20, y: 10, width: 25, height: 25)
        imageview.image = images[indexPath.row]
        imageview.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        self.delegate?.ButtonPresed(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    }
}

//Mark: this is the segmenter Delefate
protocol SegmentDelegate {
    func ButtonPresed(index: Int)
}
