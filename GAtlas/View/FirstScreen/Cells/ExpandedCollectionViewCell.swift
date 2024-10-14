//
//  ExpandedCollectionViewCell.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 14.09.2024.
//

import UIKit

protocol ExpandedCVButtonDelegate: AnyObject {
    func learnMoreInfoButton(currentCountry: CountryListModel)
}

class ExpandedCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    static let identifier = "ExpandedCollectionViewCell"
    
    private var country: CountryListModel?
    private var countryArr: [[String]] = []
    weak var delegate: ExpandedCVButtonDelegate?
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "flag")
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default name"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.text = "Default capital"
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let expandIndicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return imageView
    }()
    
    private let infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor =  #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let learnMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn More", for: .normal)
        var color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    
    func configureComponents(object: CountryListModel) {
        
        let country = object 
        flagImageView.image = country.flag
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        expandIndicatorView.image = UIImage(systemName: country.isExpanded ? "chevron.up" : "chevron.down")
        self.country = country
        countryArr = setupData()
        infoTableView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyShadows()
        setupFlagImageView()
        setupStackView()
        setupExpandImageView()
        setupTableView()
        setupButton()
        
    }
    
    private func applyShadows() {
        backgroundColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
    
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2

    }
    
    private func setupFlagImageView() {
        contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(70)
            make.width.equalTo(100)
        }
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(flagImageView.snp.trailing).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(200)

        
        }
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(capitalLabel)
    }
    
    private func setupExpandImageView() {
        contentView.addSubview(expandIndicatorView)
        
        expandIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(20)
        }
    }
    
    private func setupTableView() {
        contentView.addSubview(infoTableView)
        
        infoTableView.register(AdditionalInfoTableViewCell.self, forCellReuseIdentifier: AdditionalInfoTableViewCell.identifier)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(flagImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            
        }
    }
    
    private func setupButton() {
        contentView.addSubview(learnMoreButton)
        learnMoreButton.addTarget(self, action: #selector(leanrMoreButtonTapped), for: .touchUpInside)
        learnMoreButton.snp.makeConstraints { make in
            make.top.equalTo(infoTableView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc func leanrMoreButtonTapped() {
        let defaultValue = CountryListModel(name: "name", capital: "capital", population: 10, region: "region", flag: UIImage(systemName: "flag")!, currencies: "currency", cca2: "cca2")
        delegate?.learnMoreInfoButton(currentCountry: country ?? defaultValue)
    }
    
    
    private func setupData() -> [[String]]{
        var arr = [[String]]()
        guard let population = country?.population else { return []}
        arr.append(["Population:", String(describing: population)])
        arr.append(["Currencies:", country?.currencies ?? "empty"])
        
        return arr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExpandedCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return countryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = AdditionalInfoTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AdditionalInfoTableViewCell
        let currentCountry = countryArr[indexPath.row]
        
        cell.configureComponents(name: currentCountry[0], value: currentCountry[1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}


