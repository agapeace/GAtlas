//
//  CountryDetails.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 14.09.2024.
//

import Foundation
import UIKit
import SkeletonView


final class CountryDetails: UIViewController {
    
    var codeValue: String
    
    private let viewModel = CountryDetailsViewModel()
    private var countryArr = [FinalCountryDetails]()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.isSkeletonable = true
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        tableView.register(FlagTableViewCell.self, forCellReuseIdentifier: FlagTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(codeValue: String) {
        self.codeValue = codeValue
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        fetchData()
        setupBinders()
        
    }
    
  
    private func setupTableView() {
        view.addSubview(tableView)
       
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableView.automaticDimension
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    private func fetchData() {
        viewModel.fetchCountryDetail(tableView: tableView, code: codeValue)
    }
    
    private func setupBinders() {
        viewModel.value.bind { collection in
            self.countryArr = collection
            DispatchQueue.main.async {
                self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CountryDetails: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArr.isEmpty ? 10 : countryArr[0].countOfProperties()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return indexPath.row == 0 ? FlagTableViewCell.identifier : DetailsTableViewCell.identifier
    }
}

extension CountryDetails: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if countryArr.isEmpty {
            let cellId = indexPath.row == 0 ? FlagTableViewCell.identifier : DetailsTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.isSkeletonable = true
            return cell
        }
        
        let value = countryArr[0]
        
        if indexPath.row == 0 {
            let cellId = FlagTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FlagTableViewCell
            cell.configureComponents(image: value.flag)
            return cell
        }
        
        let cellId = DetailsTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailsTableViewCell
        
        switch indexPath.row {
            case 1:
                cell.configureComponents(name: "Country:", value: value.name)
            case 2:
                cell.configureComponents(name: "Capital:", value: value.capital)
            case 3:
                guard let coordinatesValue = value.capitalInfo.first?.value else { return cell }
                cell.configureComponents(name: "Capital coordinates:",
                                         value: "\(coordinatesValue[0]), \(coordinatesValue[1])", isLink: true)
            case 4:
                cell.configureComponents(name: "Population", value: "\(value.population)")
            case 5:
                cell.configureComponents(name: "Area", value: "\(value.area) km²")
            case 6:
                cell.configureComponents(name: "Currency", value: "\(value.currencies)")
            case 7:
                cell.configureComponents(name: "Region", value: "\(value.subregion)")
            case 8:
                cell.configureComponents(name: "Timezones", value: "\(value.timezones)")
            default:
                cell.configureComponents(name: "Default", value: "Default")
        }

        return cell

    }
}

extension CountryDetails: SkeletonTableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 220 : UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coordinates = countryArr[0].capitalInfo.first?.value else { return }
        if indexPath.row == 3 {
            viewModel.openGoogleMapsLocation(latitude: coordinates[0], longitude: coordinates[1])
        }
    }
}
