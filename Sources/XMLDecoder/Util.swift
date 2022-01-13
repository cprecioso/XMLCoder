extension Optional {
  func tryUnwrap(or error: Error) throws -> Wrapped {
    if let value = self {
      return value
    } else {
      throw error
    }
  }
}
