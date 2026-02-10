final class RandomUserService {

    private let dataProvider: ApiRandomUserProvider

    static let deletedItemIdsKey = "deletedUserIDs"
    private var deletedItemIDs: Set<Int> {
        get {
            let array = UserDefaults.standard.array(forKey: Self.deletedItemIdsKey) as? [Int] ?? []
            return Set(array)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: Self.deletedItemIdsKey)
        }
    }

    init(dataProvider: ApiRandomUserProvider = .init()) {
        self.dataProvider = dataProvider
    }

    func fetchUsers(count: Int = 50) async throws -> [UserEntity] {
        let apiResult = try await dataProvider.fetchUsers(count: count)
        let deletedIds = self.deletedItemIDs
        return apiResult.map { userDto in
            var entity = UserEntity(from: userDto)
            entity.isDeleted = deletedIds.contains(entity.id)
            return entity
        }
    }

    func applyFilter(_ filter: UsersListFilterDto, for items: [UserEntity])  -> [UserEntity] {
        var filteredItems = items
        if filter.withoutDeleted {
            filteredItems = filteredItems.filter { $0.isDeleted == false }
        }

        if let fullNameFilter = filter.fullNameFilter, !fullNameFilter.isEmpty {
            filteredItems = filteredItems.filter { $0.fullName.lowercased().contains(fullNameFilter.lowercased()) }
        }

        if let emailFilter = filter.emailFilter, !emailFilter.isEmpty {
            filteredItems = filteredItems.filter { $0.email.lowercased().contains(emailFilter.lowercased()) }
        }

        return filteredItems
    }

    func deleteItem(_ entity: UserEntity) {
        var ids = deletedItemIDs
        ids.insert(entity.id)
        deletedItemIDs = ids
    }

}
