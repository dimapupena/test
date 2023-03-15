//
//  QuotesTableViewCell.swift
//  Technical-test
//
//  Created by Dmytro Pupena on 15.03.2023.
//

import Foundation
import UIKit

class QuotesTableViewCell: UITableViewCell {
    
    var addFavoriteQuote: ((Quote?, Bool?) -> Void)?
    
    private var quoteNameLabel = UILabel()
    private var quoteLastLabel = UILabel()
    private var quoteChangePercentLabel = UILabel()
    private var quoteFavoriteButton = UIButton()
    
    private var quote: Quote?
    private var isFavorite: Bool? {
        didSet {
            addFavoriteQuote?(quote, isFavorite)
            updateView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        setupQuoteNameLabel()
        setupQuoteLastLabel()
        setupQuoteFavoriteButton()
        setupQuoteChangePercentLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quoteNameLabel.text = ""
        quoteLastLabel.text = ""
        quoteChangePercentLabel.text = ""
        quoteFavoriteButton.setImage(nil, for: .normal)
    }
    
    func setupWithData(quote: Quote?, isFavorite: Bool) {
        self.quote = quote
        self.isFavorite = isFavorite
        quoteNameLabel.text = quote?.name ?? ""
        quoteLastLabel.text = "\(quote?.last ?? "") \(quote?.currency ?? "")"
        quoteChangePercentLabel.text = quote?.readableLastChangePercent ?? ""
        if quote?.variationColor == "red" {
            quoteChangePercentLabel.textColor = .systemRed
        } else {
            quoteChangePercentLabel.textColor = .systemGreen
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupQuoteNameLabel() {
        contentView.addSubview(quoteNameLabel)
        
        quoteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        quoteNameLabel.textAlignment = .left
        quoteNameLabel.font = .systemFont(ofSize: 16)
        quoteNameLabel.textColor = .black
        
        quoteNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        quoteNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    private func setupQuoteLastLabel() {
        contentView.addSubview(quoteLastLabel)
        
        quoteLastLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLastLabel.font = UIFont.boldSystemFont(ofSize: 16)
        quoteLastLabel.textAlignment = .left
        quoteLastLabel.font = .systemFont(ofSize: 16)
        quoteLastLabel.textColor = .black
        
        quoteLastLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        quoteLastLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    private func setupQuoteFavoriteButton() {
        contentView.addSubview(quoteFavoriteButton)
        
        quoteFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        quoteFavoriteButton.addTarget(self, action: #selector(handleFavoriteButtonAction), for: .touchUpInside)
        
        quoteFavoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        quoteFavoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quoteFavoriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        quoteFavoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupQuoteChangePercentLabel() {
        contentView.addSubview(quoteChangePercentLabel)
        
        quoteChangePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteChangePercentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        quoteChangePercentLabel.textAlignment = .left
        quoteChangePercentLabel.font = .systemFont(ofSize: 24)
        
        quoteChangePercentLabel.trailingAnchor.constraint(equalTo: quoteFavoriteButton.leadingAnchor, constant: -15).isActive = true
        quoteChangePercentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func updateView() {
        if isFavorite ?? false {
            quoteFavoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            quoteFavoriteButton.setImage(UIImage(named: "no-favorite"), for: .normal)
        }
    }
    
    @objc private func handleFavoriteButtonAction() {
        isFavorite = !(isFavorite ?? true)
    }
    
}
