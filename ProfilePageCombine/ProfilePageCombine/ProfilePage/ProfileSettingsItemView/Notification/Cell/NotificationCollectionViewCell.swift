//
//  NotificationCollectionViewCell.swift
//  ProfilePageCombine
//
//  Created by Павел Кай on 28.11.2022.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NotificationCollectionViewCell"
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Mazurbek"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.text = "21.11.2022 0:23"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.text = "299 руб."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(title)
        contentView.addSubview(image)
        contentView.addSubview(date)
        contentView.addSubview(price)
        
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotificationCollectionViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            
            date.topAnchor.constraint(equalTo: title.bottomAnchor),
            date.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
        ])
    }
}
