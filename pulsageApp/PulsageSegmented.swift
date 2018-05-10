import UIKit

class PulsageSegmented: UIView {

    public var ButtonTitles: [String]?
    public var delegate: PulsageSegmentedDelegate?
    public var currentButton = ""
    
    public lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.width / 2, height: frame.size.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let framec = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        let collec = UICollectionView(frame: framec, collectionViewLayout: layout)
        collec.register(PulsageSegmentedCell.self, forCellWithReuseIdentifier: "cell")
        collec.delegate = self
        collec.dataSource = self
        collec.allowsMultipleSelection = false
        return collec
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func subviews() {
        self.addSubview(self.collection)
    }
}
//Mark: UICollectionViewdelegates and datasource
extension PulsageSegmented: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.ButtonTitles?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PulsageSegmentedCell
        cell?.titleLabel.text = self.ButtonTitles?[indexPath.item]
        cell?.titleLabel.id = self.ButtonTitles?[indexPath.row]
        if self.ButtonTitles![indexPath.row] == self.currentButton {
            cell?.titleLabel.font = UIFont.systemFont(ofSize: 20)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PulsageSegmentedCell
        cell?.titleLabel.font = UIFont.systemFont(ofSize: 20)
        guard let id = cell?.titleLabel.id else {return}
        self.delegate?.buttonPressed(id: id)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PulsageSegmentedCell
        cell?.titleLabel.font = UIFont.systemFont(ofSize: 16)
    }
}
//============================================

//Mark: PulsageSegmnetedCell for CollectionView
class PulsageSegmentedCell: UICollectionViewCell {
    public lazy var titleLabel: Label = {
        let label = Label()
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
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
        self.addSubview(self.titleLabel)
        
    }
}
//=====================================



//Mark: Delegeate For Button Pressed
protocol PulsageSegmentedDelegate {
    func buttonPressed(id: String)
}
//===================================
