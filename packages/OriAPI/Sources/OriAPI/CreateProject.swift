import Foundation
import OriDomain

public struct CreateProject: Codable, Equatable, Sendable {
    public let name: String
    public let repositoryPath: String
    public init(name: String, repositoryPath: String) {
        self.name = name
        self.repositoryPath = repositoryPath
    }
}
