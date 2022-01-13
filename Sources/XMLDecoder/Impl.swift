import Foundation

struct Impl: Decoder {
  let codingPath: [CodingKey]
  let userInfo: [CodingUserInfoKey: Any]

  let node: WrappedNode

  func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
  where Key: CodingKey {
    KeyedDecodingContainer(
      KeyedContainer<Key>(parentImpl: self, node: node, codingPath: codingPath))
  }

  func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    UnkeyedContainer(parentImpl: self, node: node, codingPath: codingPath)
  }

  func singleValueContainer() throws -> SingleValueDecodingContainer {
    SingleValueContainer(parentImpl: self, node: node, codingPath: codingPath)
  }

}
