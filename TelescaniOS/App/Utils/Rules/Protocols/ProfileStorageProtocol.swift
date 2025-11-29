protocol ProfileStorageProtocol {
    func fetch(id: String) -> ProfileInfo? // TODO: Put in a separate protocol later
    func save(_ profile: ProfileInfo)
    func delete(id: String)
    func clear()
}
