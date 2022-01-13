import Foundation

public class XMLDecoder {
  public init() {}

  public var options: XMLNode.Options = []

  public func decode<T: Decodable>(_ type: T.Type, document documentData: Data) throws -> T {
    let document = try XMLDocument(data: documentData, options: options)
    guard let rootElement = document.rootElement() else { throw Error.noRootElement }
    let decoder = Impl(codingPath: [], userInfo: [:], node: .elements([rootElement]))
    return try T(from: decoder)
  }

  public enum Error: Swift.Error {
    case noRootElement
    case noSingleElement
    case keyNotFound(String)
    case cantConvert(Any.Type)
    case notAnArray
    case emptyValue

    case string(String)
  }
}

typealias Error = XMLDecoder.Error
