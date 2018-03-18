import UIKit

class Settings: UIViewController {
    fileprivate let settings = ["Edit Profile", "Bussines Profile", "Termns & Conditions", "Private Policy", "Open Source Libraries"]
    
    fileprivate lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 50)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collectionFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let collection = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collection.register(SettingsCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Settings"
    }
    
}

extension Settings: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SettingsCell
        cell?.backgroundColor = .white
        cell?.setting.text = self.settings[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let termsCondition = About()
        switch indexPath.row {
        case 0:
            let editprofile = EditProfile()
            self.navigationController?.pushViewController(editprofile, animated: true)
        case 1:
            let bussinesProfile = CreateBussinesProfile()
            self.navigationController?.pushViewController(bussinesProfile, animated: true)
        case 2:
            termsCondition.section = "termsConditions"
            termsCondition.titleText = "Termns&Conditions"
            self.navigationController?.pushViewController(termsCondition, animated: true)
        case 3:
            termsCondition.section = "privacyPolicy"
            termsCondition.titleText = "Privacy Policy"
            self.navigationController?.pushViewController(termsCondition, animated: true)
        case 4:
            termsCondition.section = "openSource"
            termsCondition.titleText = "Open Source"
            self.navigationController?.pushViewController(termsCondition, animated: true)
        default:
            break
        }
        
        
    }
    
}
