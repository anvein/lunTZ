import Foundation

final class ApiRandomUserProvider {

    private let parser: JSONParserWrapper
    private let mapper: UsersListResponseDtoMapper

    init(parser: JSONParserWrapper = .init(), mapper: UsersListResponseDtoMapper = .init()) {
        self.parser = parser
        self.mapper = mapper
    }

    func fetchUsers(count: Int) async throws -> [UsersListItemResponseDto] {
        let url = URL(string: "https://fakerapi.it/api/v2/persons?_quantity=\(count)")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "ApiRandomUserProvider", code: 1)
        }

        let responseDict = parser.parseJSON(jsonString)

        return try mapper.map(from: responseDict)
    }
}
