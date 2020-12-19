import Fluent
import Vapor

func routes(_ app: Application) throws {
   
    app.group("api") { api in
        try! api.register(collection: AuthController())
        try! api.register(collection: UserInfoController())
        try! api.register(collection: ShoppingListController())
    }
}
