//
//  AdditionalInfoTableViewCell.swift
//  GAtlas
//
//  Created by Damir Agadilov  on 13.09.2024.
//

import UIKit

class AdditionalInfoTableViewCell: UITableViewCell {

    
    static let identifier = "AdditionalInfoTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "Default name"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Default value"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        
        setupNameLabel()
        setupValueLabel()
        
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(10)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
   
    func configureComponents(name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
