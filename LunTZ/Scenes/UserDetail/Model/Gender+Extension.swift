extension Gender {
    var title: String? {
        switch self {
        case .male: "мужчина"
        case .female: "женщина"
        case .unknown: nil
        }
    }
}
