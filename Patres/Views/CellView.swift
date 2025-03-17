//
//  CellView.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import Foundation
import UIKit

class CellView: UITableViewCell {
    //MARK: - Varaibels
    public static let identifier = "CellView"
    
    //MARK: - UI Compontns
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor  = .red
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart") , for: .normal)
        button.setImage(UIImage(systemName: "heart.fill") , for: .selected)
        button.tintColor = .red
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Cell Configuration
    public func configureCell(with post: Post){
        self.avatarImageView = post.avatarImage
        self.postImageView = post.postImage
        self.usernameLabel.text = post.username
        self.captionLabel.text = post.caption
    }
    
    //MARK: - Initlizer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    //MARK: -  Setup UI
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(postImageView)
        addSubview(captionLabel)
        addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 30),
            avatarImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -5),
            
            usernameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 45),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.layoutMarginsGuide.trailingAnchor, constant: 20 ),
    
            postImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: frame.width - 20),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    //MARK: - Selectors
    @objc private func likeButtonTapped() {
        print("like button tapped")
    }
}
