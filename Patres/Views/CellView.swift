//
//  CellView.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

class CellView: UITableViewCell {
    
    // MARK: - Properties
    public static let identifier = "CellView"
    private var isLiked: Bool = false
    
    // MARK: - UI Components
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
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
        button.tintColor = .red
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .gray
        
        return spinner
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    //MARK: - Cell Configuration
    public func configure(with post: PostDecoded){
        handleAvatarImage(with: post)
        handlePostImage(with: post)
        usernameLabel.text = post.username
        captionLabel.text = post.caption
        isLiked = post.isLiked 
        
    }
    
    // download the images from the decoded url to the ui components
    private func downloadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                    self.loadingSpinner.stopAnimating()
                }
            }
        }
    }
    // avatar image url
    private func handleAvatarImage(with post: PostDecoded) {
        if let url = URL(string: post.avatarUrl ?? "") {
            downloadImage(from: url, into: avatarImageView)
        }else {
            avatarImageView.image = UIImage(systemName: "person")
        }
    }
    
    //post image url
    private func handlePostImage(with post: PostDecoded) {
        if let postImageUrl = URL(string: post.postImageUrl ?? "" ) {
            loadingSpinner.startAnimating()
            downloadImage(from: postImageUrl, into: postImageView)
        }else {
            postImageView.image = UIImage(systemName: "questionmark.app")
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(postImageView)
        addSubview(captionLabel)
        addSubview(likeButton)
        addSubview(loadingSpinner)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.layoutMarginsGuide.trailingAnchor, constant: 20 ),
            
            postImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: frame.width - 20),
            postImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            
        ])
        
        self.layoutIfNeeded()
        bringSubviewToFront(likeButton)
    }
    
    //MARK: -  Like Button UI manibulate
    private func updateLikeButtonUI() {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.isSelected = isLiked
    }
    
    //MARK: - Selectors
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        updateLikeButtonUI()
    }
}
