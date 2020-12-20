import Fluent
import FluentPostgresDriver
import Vapor
import JWT


// configures your application
public func configure(_ app: Application) throws {

    app.databases.use(.postgres(hostname: "localhost",
                                port: 5432,
                                username: "dbuser",
                                password: "62egegos",
                                database: "shopinglistapp"), as: .psql)

    
    app.jwt.signers.use(.hs256(key: "secret"))
    try migrations(app)
    try services(app)
    try routes(app)
    try middleware(app)
}
