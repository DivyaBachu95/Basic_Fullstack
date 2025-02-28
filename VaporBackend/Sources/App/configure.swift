import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// Configures your application
public func configure(_ app: Application) async throws {
    // Serve files from the /Public folder if needed
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let tlsConfig = (Environment.get("DATABASE_USE_TLS") == "true") ? TLSConfiguration.forClient() : nil

    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tlsConfiguration: tlsConfig
    ), as: .mysql)

    app.migrations.add(CreateTodo())

    app.views.use(.leaf)

    // Register routes
    try routes(app)
}
