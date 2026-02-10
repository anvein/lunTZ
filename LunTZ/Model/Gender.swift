enum Gender: String {
    case male
    case female
    case unknown

    init(from string: String) {
        switch string.lowercased() {
        case "male": self = .male
        case "female": self = .female
        default: self = .unknown
        }
    }
}
