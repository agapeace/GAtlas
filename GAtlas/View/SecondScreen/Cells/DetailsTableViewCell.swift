
import UIKit
import SkeletonView


class DetailsTableViewCell: UITableViewCell {

    static let identifier = "DetailsTableViewCell"
    
    private let dotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .black
        imageView.isSkeletonable = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.isSkeletonable = true
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.isSkeletonable = true
        return label
    }()
    
    func configureComponents(name: String, value: String, isLink: Bool = false) {
        nameLabel.text = name
        valueLabel.text = value
        
        isLink == true ? isCellLink(value: value) : ()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupDotImageView()
        setupNameLabel()
        setupValueLabel()
    }
    
    private func setupDotImageView() {
        contentView.backgroundColor = .white
        contentView.addSubview(dotImageView)
        
        dotImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(15)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.leading.equalTo(dotImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(dotImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func isCellLink(value: String) {
        valueLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0.9333333333, alpha: 1)
        let attributedString = NSMutableAttributedString(string: "\(value)")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
                    
        valueLabel.attributedText = attributedString
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
