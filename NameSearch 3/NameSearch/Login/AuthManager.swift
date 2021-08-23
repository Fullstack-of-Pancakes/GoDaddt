class AuthManager {
    static var shared = AuthManager()

    private init() { }
    
    var user: User?
    var token: String?
}
