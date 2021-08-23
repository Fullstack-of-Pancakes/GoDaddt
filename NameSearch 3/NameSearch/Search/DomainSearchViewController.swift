import UIKit

struct Domain {
    let name: String
    let price: String
    let productId: Int
}

class DomainSearchViewController: UIViewController {

    static func createVC() -> DomainSearchViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "\(DomainSearchViewController.self)") as? DomainSearchViewController
        return vc
    }
    
    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!
    
    var service: NetworkService?

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTermsTextField.resignFirstResponder()
        self.loadData()
    }

    @IBAction func cartButtonTapped(_ sender: UIButton) {
        guard let vc = CartViewController.createVC() else { return }
//        vc.service = self.service
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var data: [Domain] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DomainTableViewCell.self, forCellReuseIdentifier: DomainTableViewCell.reusedID)
        configureCartButton()
    }

    func loadData() {
        
        guard let searchTerms = searchTermsTextField.text else { return }
        self.service?.requestData(request: NetworkRequests.searchExact(searchTerms).request, completion: { (result: Result<DomainSearchExactMatchResponse, Error>) in
            switch result {
            case .success(let exactResponse):
                
                guard let exactDomainPriceInfo = exactResponse.products.first(where: { $0.productId == exactResponse.domain.productId })?.priceInfo else { return }
                let exactDomain = Domain(name: exactResponse.domain.fqdn,
                                         price: exactDomainPriceInfo.currentPriceDisplay,
                                         productId: exactResponse.domain.productId)
                
                
                self.service?.requestData(request: NetworkRequests.searchSuggestion(searchTerms).request, completion: { (result: Result<DomainSearchRecommendedResponse, Error>) in
                    switch result {
                    case .success(let suggestionsResponse):
                        
                        let suggestionDomains = suggestionsResponse.domains.compactMap { domain -> Domain? in
                            guard let priceInfo = suggestionsResponse.products.first(where: { price in
                                price.productId == domain.productId
                            })?.priceInfo else { return nil }
                            
                            return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
                        }
                        
                        self.data.append(contentsOf: [exactDomain] + suggestionDomains)
                        
                    case .failure(let error):
                        print(error)
                    }
                })
                
                
            case .failure(let error):
                print(error)
            }
        })
        
        
    }

    private func configureCartButton() {
        cartButton.isEnabled = !ShoppingCart.shared.domains.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }
}

extension DomainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Not recycling cells
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DomainTableViewCell.reusedID, for: indexPath) as? DomainTableViewCell else {
            return UITableViewCell()
        }
        // force unwraps
        cell.textLabel?.text = data[indexPath.row].name
        cell.detailTextLabel?.text = data[indexPath.row].price

        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == data[indexPath.row].name })

        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DomainSearchViewController: UITableViewDelegate {
    // Force unwraps
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = data[indexPath.row]
        ShoppingCart.shared.domains.append(domain)

        configureCartButton()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = data[indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }

        configureCartButton()
    }
}
