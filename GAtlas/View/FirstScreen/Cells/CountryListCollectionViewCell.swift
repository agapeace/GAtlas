//
//  CountryListCollectionViewCell.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 14.09.2024.
//

import UIKit
import SkeletonView

 protocol ConfigurableCell {
    func configureComponents(object: CountryListModel)
}


class CountryListCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    static let identifier = "CountryListCollectionViewCell"
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "flag")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default name"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .black)
        label.isSkeletonable = true
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.text = "Default capital"
        label.textColor = .gray
        label.numberOfLines = 0
        label.isSkeletonable = true
        return label
    }()
    
    private let expandIndicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        imageView.isSkeletonable = true
        return imageView
    }()
    
    func configureComponents(object: CountryListModel) {
        
        let country = object 
        flagImageView.image = country.flag 
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        expandIndicatorView.image = UIImage(systemName: country.isExpanded ? "chevron.up" : "chevron.down")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyShadows()
        setupFlagImageView()
        setupStackView()
        setupExpandImageView()
    }
    
    private func applyShadows() {
        backgroundColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        contentView.isSkeletonable = true
    
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
//        contentView.layer.masksToBounds = false
    }
    
    private func setupFlagImageView() {
        contentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview().inset(10)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
