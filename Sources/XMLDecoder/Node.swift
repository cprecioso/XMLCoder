import Foundation

enum WrappedNode {
  case elements([XMLElement])
  case attribute(XMLNode)

  func getSingleElement() throws -> XMLElement {
    guard case .elements(let els) = self,
      els.count == 1
    else { throw Error.noSingleElement }

    return els.first!
  }

  func getSingleNode() throws -> XMLNode {
    if case .attribute(let node) = self {
      return node
    } else {
      return try getSingleElement()
    }
  }

  func getElementArray() throws -> [XMLElement] {
    guard case .elements(let els) = self else { throw Error.notAnArray }
    return els
  }
}
