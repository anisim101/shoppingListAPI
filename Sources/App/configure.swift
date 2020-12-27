import Fluent
import FluentPostgresDriver
import Vapor
import JWT


// configures your application
public func configure(_ app: Application) throws {
    
//    if true {
//        app.databases.use(.postgres(hostname: "localhost",
//                                    port: 1212,
//                                    username: "postgres",
//                                    password: "",
//                                    database: "shoppingapp"), as: .psql)
//    } else {
        app.databases.use(.postgres(hostname: "localhost",
                                    port: 5432,
                                    username: "dbuser",
                                    password: "62egegos",
                                    database: "shopinglistapp"), as: .psql)
//
//    }

 
    
    app.jwt.apple.applicationIdentifier = "com.tegoo.app"
    app.jwt.signers.use(.hs256(key: "secret"))
    try migrations(app)
    try services(app)
    try routes(app)
    try middleware(app)
}
