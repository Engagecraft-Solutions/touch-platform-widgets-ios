
public class Touch {
    var consumerid = ""
    
    public static var shared = Touch()
    
    public func setup(consumerid: String){
        self.consumerid = consumerid
    }
}

