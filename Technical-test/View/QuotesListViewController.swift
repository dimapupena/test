//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController {
    
    private let dataManager:DataManager = DataManager()
    private var market:Market? = nil
    
    private var loaderView = UIActivityIndicatorView()
    private var quotesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupQuotesTableView()
        setupLoaderView()
        
        loadData()
    }
    
    private func loadData() {
        loaderView.startAnimating()
        dataManager.fetchQuotes { [weak self] quotes in
            guard let self = self else { return }
            self.market = Market()
            self.market?.quotes = quotes
            DispatchQueue.main.async {
                self.quotesTableView.reloadData()
                self.loaderView.stopAnimating()
            }
        }
    }
    
    private func setupLoaderView() {
        view.addSubview(loaderView)
        loaderView.stopAnimating()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.startAnimating()
        loaderView.style = UIActivityIndicatorView.Style.large
        loaderView.backgroundColor = .gray
        loaderView.alpha = 0.7
        loaderView.color = .systemBlue
        
        loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupQuotesTableView() {
        quotesTableView.isPagingEnabled = false
        quotesTableView.backgroundColor = .white
        quotesTableView.register(QuotesTableViewCell.self, forCellReuseIdentifier: "QuotesTableViewCell")
        quotesTableView.translatesAutoresizingMaskIntoConstraints = false
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        
        view.addSubview(quotesTableView)
        quotesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quotesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        quotesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quotesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func addFaforiteQuote(quote: Quote?, _ add: Bool?) {
        guard let quote = quote, let name = quote.name, let add = add else { return }
        if add {
            UserDefaults.standard.set(true, forKey: name)
        } else {
            UserDefaults.standard.removeObject(forKey: name)
        }
    }
    
}

extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return market?.quotes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesTableViewCell", for: indexPath) as! QuotesTableViewCell
        let quote = market?.quotes?[indexPath.row]
        cell.setupWithData(quote: quote, isFavorite: UserDefaults.standard.bool(forKey: quote?.name ?? ""))
        cell.addFavoriteQuote = { [weak self] quote, add in
            self?.addFaforiteQuote(quote: quote, add)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let quote = market?.quotes?[indexPath.row] else { return }
        let quoteDetailsVC = QuoteDetailsViewController(quote: quote, isFavorite: UserDefaults.standard.bool(forKey: quote.name ?? ""))
        quoteDetailsVC.addFavoriteQuote = { [weak self] quote, add in
            guard let self = self else { return }
            self.addFaforiteQuote(quote: quote, add)
            tableView.reloadRows(at: [indexPath], with: .none)
            self.navigationController?.dismiss(animated: true)
        }
        navigationController?.present(quoteDetailsVC, animated: true)
    }
    
}
