import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var service: NetworkService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = NetworkManager()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        login(with: username, password: password) { [weak self] (result) in
            switch result {
            case .success(let loginResponse):
                AuthManager.shared.user = loginResponse.user
                AuthManager.shared.token = loginResponse.auth.token
                
                self?.navigate()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func login(with username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let dict: [String: String] = [
            "username": username,
            "password": password
        ]
        
        self.service?.requestData(request: NetworkRequests.login(dict).request) { (result: Result<LoginResponse, Error>) in
            completion(result)
        }
    }
    
    func navigate() {
        DispatchQueue.main.async {
            guard let vc = DomainSearchViewController.createVC() else { return }
            vc.service = self.service
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
