import Foundation

struct UnkeyedContainer: UnkeyedDecodingContainer {
  let parentImpl: Impl
  let node: WrappedNode
  let codingPath: [CodingKey]

  var count: Int? {
    try? node.getElementArray().count
  }

  var currentIndex: Int = 0

  var isAtEnd: Bool {
    currentIndex >= (count ?? 0)
  }

  mutating func nextDecoder() throws -> some Decoder {
    let el = try node.getElementArray()[currentIndex]
    let impl = Impl(codingPath: codingPath, userInfo: parentImpl.userInfo, node: .elements([el]))

    self.currentIndex += 1

    return impl
  }

  mutating func decodeNil() throws -> Bool {
    false
  }

  mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    let decoder = try nextDecoder()
    return try T(from: decoder)
  }

  mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
    -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
  {
    try nextDecoder().container(keyedBy: type)
  }

  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    try nextDecoder().unkeyedContainer()
  }

  mutating func superDecoder() throws -> Decoder {
    throw Error.keyNotFound("super")
  }

}
