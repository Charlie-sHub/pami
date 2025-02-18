/// The type of a ContactMessage
enum ContactMessageType {
  /// General feedback about the app
  feedback,

  /// Reporting a bug or technical issue
  bugReport,

  /// Suggesting a new feature
  featureRequest,

  /// Issues related to login, registration, or account management
  accountIssue,

  /// Reporting inappropriate behavior or content
  abuseReport,

  /// Any other type of contact message
  other,
}
