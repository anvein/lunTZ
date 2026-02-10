final class UsersListResponseDtoMapper {

    func map(from fullResponse: [String: Any]) throws -> [UsersListItemResponseDto] {
        guard let itemsRoot = fullResponse["data"] as? [[String: Any]] else {
            throw NSError(
                domain: "UsersListResponseDtoMapper",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Missing data node with items"]
            )
        }
        return try mapItemsArray(from: itemsRoot)
    }

    private func mapItemsArray(from array: [[String: Any]]) throws -> [UsersListItemResponseDto] {
        try array.map { try mapItem(from: $0) }
    }

    private func mapItem(from itemDict: [String: Any]) throws -> UsersListItemResponseDto {
        return UsersListItemResponseDto(
            id: try value("id", itemDict),
            email: try value("email", itemDict),
            firstName: try value("firstname", itemDict),
            lastName: try value("lastname", itemDict),
            phone: try value("phone", itemDict),
            gender: try value("gender", itemDict),
            avatar: try value("image", itemDict),
            address: try mapAddress(from: value("address", itemDict))
        )
    }

    private func mapAddress(from dict: [String: Any]) throws -> AddressDto {
        return AddressDto(
            street: try value("street", dict),
            streetName: try value("streetName", dict),
            buildingNumber: try value("buildingNumber", dict),
            city: try value("city", dict),
            country: try value("country", dict)
        )
    }

    private func value<T>(_ key: String, _ dict: [String: Any]) throws -> T {
        guard let value = dict[key] as? T else {
            throw NSError(
                domain: "UsersListResponseDtoMapper",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Missing or invalid field: \(key)"]
            )
        }
        return value
    }
}
