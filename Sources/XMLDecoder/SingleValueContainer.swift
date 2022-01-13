import Foundation

struct SingleValueContainer: SingleValueDecodingContainer {

  let parentImpl: Impl
  let node: WrappedNode
  let codingPath: [CodingKey]

  func decodeNil() -> Bool {
    (try? node.getSingleNode().stringValue) == nil
  }

  func getValue() throws -> String {
    try node.getSingleNode().stringValue.tryUnwrap(or: .emptyValue)
  }

  func decode(_ type: String.Type) throws -> String {
    try getValue()
  }

  func decodeLossless<T: LosslessStringConvertible>(_ type: T.Type) throws -> T {
    try T(getValue()).tryUnwrap(or: .cantConvert(T.self))
  }

  func decode(_ type: Bool.Type) throws -> Bool {
    try decodeLossless(type)
  }

  func decode(_ type: Double.Type) throws -> Double {
    try decodeLossless(type)
  }

  func decode(_ type: Float.Type) throws -> Float {
    try decodeLossless(type)
  }

  func decode(_ type: Int.Type) throws -> Int {
    try decodeLossless(type)
  }

  func decode(_ type: Int8.Type) throws -> Int8 {
    try decodeLossless(type)
  }

  func decode(_ type: Int16.Type) throws -> Int16 {
    try decodeLossless(type)
  }

  func decode(_ type: Int32.Type) throws -> Int32 {
    try decodeLossless(type)
  }

  func decode(_ type: Int64.Type) throws -> Int64 {
    try decodeLossless(type)
  }

  func decode(_ type: UInt.Type) throws -> UInt {
    try decodeLossless(type)
  }

  func decode(_ type: UInt8.Type) throws -> UInt8 {
    try decodeLossless(type)
  }

  func decode(_ type: UInt16.Type) throws -> UInt16 {
    try decodeLossless(type)
  }

  func decode(_ type: UInt32.Type) throws -> UInt32 {
    try decodeLossless(type)
  }

  func decode(_ type: UInt64.Type) throws -> UInt64 {
    try decodeLossless(type)
  }

  func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
    try T(from: self.parentImpl)
  }
}
