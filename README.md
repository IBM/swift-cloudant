# swift-cloudant

A native client for direct interaction with Cloudant and CouchDB in Swift.

## Features

SwiftCloudant enables Swift applications to directly interface with Cloudant / CouchDB instances and clusters.

The following operations are supported:

- Getting documents by doc ID.
- Updating and deleting documents.
- Creating and deleting databases.
- Changes Feed operations
- Creating, updating and deleting of attachments.
- Querying views.
- Creating, deleting and querying indexes.

## Documentation

[Documentation for SwiftCloudant](https://ibm.github.io/swift-cloudant/documentation/swiftcloudant/) is available via the repo's Github Pages site.
 
The Github page for documentation is generated and updated automatically using a Github Workflow & DocC upon successful push to the `docs` branch of the repo.

## Support

`SwiftCloudant` is supported on a "best effort" basis, and only in the free time of software engineers at [IBM](https://github.com/ibm).

Although the original project was started by [@Cloudant](https://github.com/cloudant), that original repository was deprecated and archived in 2019. 
Do not contact any maintainers of this project without commits later than June 2023. Cloudant has no connection to this repository and cannot help or provide any support-- if support is needed, please open an issue against [this project](https://github.com/ibm/swift-cloudant)'s repository.

### Languages

This package only supports Swift, it does not currently have any support for Objective-C. 

Please open a PR if you would like to add support, or open an issue to request our team to look at adding support.

### Supported Platforms

Swift Cloudant support is fully verified for:

Swift versions
- Minimum Swift language version 4.2
- Minimum Swift tools version 5.0

Platforms
- Linux
- Swift-on-server (e.g. Vapor)
- iOS
- iPadOS
- macOS (including catalyst applications)

Swift Cloudant support is not verified / tested for:
- visionOS
- tvOS
- watchOS

(it may work, but we have not verified. feel free to issue a PR if you get it running for these platforms)

## Usage

SwiftCloudant is available using the Swift Package Manager and [CocoaPods](http://cocoapods.org).

To use with CocoaPods add the following line to your Podfile:

```ruby
pod 'SwiftCloudant', :git => 'https://github.com/cloudant/swift-cloudant.git'
```

To use with the swift package manager add the following line to your dependencies
in your Package.swift:
```swift
.Package(url: "https://github.com/cloudant/swift-cloudant.git")
```
## <a name="overview"></a>Overview of the library
```swift
import SwiftCloudant

// Create a CouchDBClient
let cloudantURL = URL(string:"https://username.cloudant.com")!
let client = CouchDBClient(url:cloudantURL, username:"username", password:"password")
let dbName = "database"

// Create a document
let create = PutDocumentOperation(id: "doc1", body: ["hello":"world"], databaseName: dbName) {(response, httpInfo, error) in
    if let error = error as? SwiftCloudant.Operation.Error {
        switch error {
        case .http(let httpError):
            print("http error status code: \(httpError.statusCode)  response: \(httpError.response)")
        default:
            print("Encountered an error while creating a document. Error:\(error)")
        }
    } else {
        print("Created document \(response?["id"]) with revision id \(response?["rev"])")
    }
}
client.add(operation:create)

// create an attachment
let attachment = "This is my awesome essay attachment for my document"
let putAttachment = PutAttachmentOperation(name: "myAwesomeAttachment",
    contentType: "text/plain",
    data: attachment.data(using: String.Encoding.utf8, allowLossyConversion: false)!,
    documentID: "doc1",
    revision: "1-revisionidhere",
    databaseName: dbName) { (response, info, error) in
        if let error = error {
            print("Encountered an error while creating an attachment. Error:\(error)")
        } else {
            print("Created attachment \(response?["id"]) with revision id \(response?["rev"])")
        }       
    }   
client.add(operation: putAttachment)

// Read a document
let read = GetDocumentOperation(id: "doc1", databaseName: dbName) { (response, httpInfo, error) in
    if let error = error {
        print("Encountered an error while reading a document. Error:\(error)")
    } else {
        print("Read document: \(response)")
    }   
}
client.add(operation:read)

// Delete a document
let delete = DeleteDocumentOperation(id: "doc1",
    revision: "1-revisionidhere",
    databaseName: dbName) { (response, httpInfo, error) in
    if let error = error {
        print("Encountered an error while deleting a document. Error: \(error)")
    } else {
        print("Document deleted")
    }   
}
client.add(operation:delete)
```

## Requirements

The only dependency of the framework is a plugin that is published and maintained by Apple for generating DocC documentation, but it isn't required for anything other than generating documentation.

This framework has no third-party dependencies.

### Developers

### Github Workflows

CI/CD is an important part of the sustainability and maintenance of any project. We leverage Github actions via workflow automations for that purpose.

// TODO: add final info on built & test automation config
// TODO: add final info on documentation automation config

## Contributors

See [CONTRIBUTORS](CONTRIBUTORS).

## Contributing to the project

See [CONTRIBUTING](CONTRIBUTING.md).

## Legal

Swift-Cloudant is an [Apache CouchDB&trade;][acdb] client written in Swift. 

It was originally is built by [Cloudant](https://cloudant.com), and is maintained by software engineers and Swift enthusiasts at [IBM](https://github.com/ibm). This project is available under the [Apache 2.0 license][ap2].

[ap2]: https://github.com/cloudant/sync-android/blob/master/LICENSE
[acdb]: http://couchdb.apache.org/

See [LICENSE](LICENSE) for more information.
