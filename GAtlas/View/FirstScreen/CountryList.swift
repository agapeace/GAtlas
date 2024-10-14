
import UIKit
import SnapKit
import SkeletonView
import UserNotifications

final class CountryList: UIViewController {

    var countryArr = [[CountryListModel]]()
    private let viewModel = CountryListViewModel()
    var randomCountry: CountryListModel?
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(CountryListCollectionViewCell.self,
                                forCellWithReuseIdentifier: CountryListCollectionViewCell.identifier)
        collection.register(ExpandedCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExpandedCollectionViewCell.identifier)
        collection.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collection.isSkeletonable = true
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "World Countries"
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupCollectionView()
        fetchData()
        setupBinders()
        setupNotificationCenter()
    }
    
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
            
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func fetchData() {
        viewModel.fetchAllCountries(collectionView: collectionView)
    }
    
    private func setupBinders() {
        viewModel.observableValue.bind { collection in
            self.countryArr = collection
            print(CacheManager.shared.getCacheCount())
            DispatchQueue.main.async {
                self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupNotificationCenter() {
        viewModel.setupNotificationCenter(viewController: self)
    }
}


extension CountryList: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        
        return CountryListCollectionViewCell.identifier
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return countryArr.isEmpty ? 1 : countryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if countryArr.isEmpty {
            return Int(view.frame.height / 90)
        }
        
        return countryArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if countryArr.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryListCollectionViewCell.identifier, for: indexPath)
            cell.isSkeletonable = true
            return cell
        }
        let currentRegion = countryArr[indexPath.section]
        let currentCountry = currentRegion[indexPath.item]
        
        let cellIdentifier = currentCountry.isExpanded ? ExpandedCollectionViewCell.identifier : CountryListCollectionViewCell.identifier
              
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.isSkeletonable = true
              
        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configureComponents(object: currentCountry)
            
            if let expandedCell = configurableCell as? ExpandedCollectionViewCell {
                expandedCell.delegate = self
            }
        }
        
        return cell
    }
}

extension CountryList: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = view.frame.size.width - 30
        
        if countryArr.isEmpty {
            return CGSize(width: screenSize, height: 90)
        }
        
        let currentRegion = countryArr[indexPath.section]
        let isExpanded = currentRegion[indexPath.item].isExpanded
       
        return isExpanded ? CGSize(width: screenSize, height: 210) : CGSize(width: screenSize, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        countryArr[indexPath.section][indexPath.item].isExpanded.toggle()
        UIView.animate(withDuration: 0.5) {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerId = HeaderCollectionReusableView.identifier
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionReusableView
        
        if countryArr.isEmpty {
            
            header.isSkeletonable = true
            return header
        }
        
        let currentSection = countryArr[indexPath.section]
        let currentCountry = currentSection[0]
        header.configureHeader(title: currentCountry.region)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 50)
    }

}

extension CountryList: ExpandedCVButtonDelegate {
    func learnMoreInfoButton(currentCountry: CountryListModel) {
        viewModel.pushDetailsViewController(navigation: self, code: currentCountry.cca2)
    }
}
