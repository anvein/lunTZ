import Foundation

struct UserDetailVM {
    let avatar: URL?
    let fullName: String
    let email: String
    let phone: String
    let address: String
    let gender: String?

    init(from entity: UserEntity) {
        self.avatar = URL(string: entity.avatar)
        self.fullName = entity.fullName
        self.email = entity.email
        self.phone = entity.phone
        self.address = entity.address
        self.gender = entity.gender.title
    }
}
