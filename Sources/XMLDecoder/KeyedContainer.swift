import Foundation

struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
  let parentImpl: Impl
  let node: WrappedNode
  let codingPath: [CodingKey]

  var allKeys: [K] {
    guard let el = try? node.getSingleElement() else {
      return []
    }

    let attributeKeys = el.attributes?
      .compactMap { $0.name }
      .map { "@\($0)" }
    let childrenKeys = el.children?
      .compactMap { $0.name }

    let allKeys =
      ((attributeKeys ?? []) + (childrenKeys ?? []))
      .compactMap { K(stringValue: $0) }

    return allKeys
  }

  func contains(_ key: K) -> Bool {
    allKeys.contains { $0.stringValue == key.stringValue }
  }

  func decodeNil(forKey key: K) throws -> Bool {
    !contains(key)
  }

  func decoder(forKey key: K) throws -> some Decoder {
    let keyName = key.stringValue
    let isAttribute = keyName.starts(with: "@")

    let node: WrappedNode

    if isAttribute {
      let attrName = String(keyName.dropFirst(1))
      guard let attrNode = try self.node.getSingleElement().attribute(forName: attrName) else {
        throw Error.keyNotFound(keyName)
      }
      node = .attribute(attrNode)
    } else {
      let elements = try self.node.getSingleElement().elements(forName: keyName)
      node = .elements(elements)
    }

    var newCodingPath = self.codingPath
    newCodingPath.append(key)

    let impl = Impl(codingPath: newCodingPath, userInfo: parentImpl.userInfo, node: node)
    return impl
  }

  func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
    let decoder = try decoder(forKey: key)
    return try T(from: decoder)
  }

  func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws
    -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
  {
    try decoder(forKey: key).container(keyedBy: type)
  }

  func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
    try decoder(forKey: key).unkeyedContainer()
  }

  func superDecoder() throws -> Decoder {
    guard let key = K(stringValue: "super") else { throw Error.keyNotFound("super") }
    return try superDecoder(forKey: key)
  }

  func superDecoder(forKey key: K) throws -> Decoder {
    try decoder(forKey: key)
  }
}
