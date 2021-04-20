
public class Touch {
    public static var shared = Touch()
    
    var clientId = ""
    
    // Setup Touch SDK
    // ClientId: client id provided by platform
    // userId:  unique user identificator, if available at setup time
    public func setup(clientId: String, loginDelegate: TouchLoginManagerProtocol? = nil, userId:String? = nil){
        self.clientId = clientId
        ssoManager.loginDelegate = loginDelegate
        APIManager.shared.setup(client: "AN664b9cA2kwBWoNQJomX45nh", environment: environment)
        login(userId: userId)
    }
    
    private var ssoManager = SSOManager.shared
    private weak var ssoDelegate: TouchLoginManagerProtocol?
    
    // call this everytime user successfully logs in on Host app
    public func login(userId: String?){
        ssoManager.login(userId: userId)
    }
    
    // call this everytime user logs out on Host app
    public func logout(){
        ssoManager.logout()
    }
    
    internal func requestLogin(){
        print("Touch Login requested")
        ssoManager.requestLogin()
    }
    
    internal var language:String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    internal let environment = ".int"
    
    internal func widgetURL(for id:String, location: String, language: String? = nil, preview: Bool = false)-> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "widgets\(environment).touch.global"
        urlComponents.path = "/js/vendor/static/app.html"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "hash", value: id))
        queryItems.append(URLQueryItem(name: "language", value: language ?? self.language))
        if let uid = ssoManager.userId {
            queryItems.append(URLQueryItem(name: "userID", value: uid))
        }
        queryItems.append(URLQueryItem(name: "clientID", value: clientId))
        if preview{
            queryItems.append(URLQueryItem(name: "preview", value: "true"))
        }
        queryItems.append(URLQueryItem(name: "location", value: location))

        //debug
        //queryItems.append(URLQueryItem(name: "debug", value: "true"))
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

