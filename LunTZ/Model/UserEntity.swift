struct UserEntity {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    let gender: Gender
    let avatar: String
    let address: String
    var isDeleted: Bool = false

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    init(from apiDto: UsersListItemResponseDto) {
        id = apiDto.id
        email = apiDto.email
        firstName = apiDto.firstName
        lastName = apiDto.lastName
        phone = apiDto.phone
        gender = Gender(from: apiDto.gender)
        avatar = apiDto.avatar//Self.imageUrls.randomElement()! //apiDto.avatar (сервисы картинок заблокированы, пока так)
        address = "\(apiDto.address.country), \(apiDto.address.city), \(apiDto.address.streetName), \(apiDto.address.buildingNumber)"
    }

    static let imageUrls = [
        "https://loremflickr.com/1024/768/dog",
            "https://loremflickr.com/1280/960/cat",
            "https://loremflickr.com/1600/1200/bird",
            "https://loremflickr.com/1920/1080/flower",
            "https://loremflickr.com/2048/1536/car",
            "https://loremflickr.com/1280/800/horse",
            "https://loremflickr.com/1440/900/sunset",
            "https://loremflickr.com/1920/1200/mountain",
            "https://loremflickr.com/1600/900/forest",
            "https://loremflickr.com/1366/768/beach",

            "https://loremflickr.com/1920/1080/river",
            "https://loremflickr.com/2048/1365/lake",
            "https://loremflickr.com/1600/1200/city",
            "https://loremflickr.com/1280/1024/night",
            "https://loremflickr.com/1920/1280/street",
            "https://loremflickr.com/2048/1536/architecture",
            "https://loremflickr.com/1600/900/coffee",
            "https://loremflickr.com/1440/1080/book",
            "https://loremflickr.com/1920/1440/food",
            "https://loremflickr.com/2048/1365/animal",

            "https://loremflickr.com/1600/1200/travel",
            "https://loremflickr.com/1920/1080/space",
            "https://loremflickr.com/2048/1536/abstract",
            "https://loremflickr.com/1600/900/texture",
            "https://loremflickr.com/1280/720/sport",
            "https://loremflickr.com/1920/1080/bicycle",
            "https://loremflickr.com/2048/1365/motorcycle",
            "https://loremflickr.com/1600/1200/boat",
            "https://loremflickr.com/1440/900/train",
            "https://loremflickr.com/1920/1200/sky",

            "https://loremflickr.com/2048/1536/ocean",
            "https://loremflickr.com/1600/900/waterfall",
            "https://loremflickr.com/1920/1080/bridge",
            "https://loremflickr.com/1280/960/castle",
            "https://loremflickr.com/1600/1200/island",
            "https://loremflickr.com/2048/1536/desert",
            "https://loremflickr.com/1920/1080/park",
            "https://loremflickr.com/1600/900/wildlife",
            "https://loremflickr.com/2048/1365/portrait",
            "https://loremflickr.com/1920/1280/festival",

            "https://loremflickr.com/1600/1200/nightlife",
            "https://loremflickr.com/2048/1536/stars",
            "https://loremflickr.com/1920/1080/rain",
            "https://loremflickr.com/1600/900/snow",
            "https://loremflickr.com/2048/1365/autumn",
            "https://loremflickr.com/1920/1200/spring",
            "https://loremflickr.com/1600/1200/summer",
            "https://loremflickr.com/1440/900/winter",
            "https://loremflickr.com/2048/1536/forestpath",
            "https://loremflickr.com/1920/1080/flowersfield"
    ]

}
