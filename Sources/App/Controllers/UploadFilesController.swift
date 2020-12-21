//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

public enum ImageType: String, Codable {
    case userAvatar = "user_avatar"
    
    func folderName() -> String {
        return self.rawValue
    }
}

class UploadFilesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.on(.POST, "images", body: .collect(maxSize: "40mb"), use: uploadFile)
    }
    
    private func uploadFile(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<String>> {
        
        struct Input: Content {
            var file: File
            var imageType: ImageType
        }
        
        guard let input = try? req.content.decode(Input.self) else {
            throw RequestError.invalidJson
        }
        
        let folderName = input.imageType.folderName()
        let fileName =  UUID().uuidString + Date().timeIntervalSinceNow.description + input.file.filename
        let path = req.application.directory.resourcesDirectory + folderName + "/" + fileName
        return req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMapThrowing { _ -> String in
                        do {
                            try handle.close()
                        } catch {
                            throw InternalError.internalError
                        }
                        return fileName
                    }
                    .map {
                        return  SuccessResponseModel(data: $0)
                    }
            }
    }
    
}
