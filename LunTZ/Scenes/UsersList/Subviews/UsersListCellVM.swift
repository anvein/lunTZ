import Foundation

struct UsersListCellVM {
    let avatarUrl: URL?
    let fullName: String
    let email: String
    let phone: String

    init(from entity: UserEntity) {
        avatarUrl = URL(string: entity.avatar)
        fullName = entity.fullName
        email = entity.email
        phone = entity.phone
    }
}
