# swift-cloudant
 
A Swift Lang client for Cloudant and CouchDB

Note, 6/22/2023:

This framework lives in this repo under the @IBM org, but is a fork from the [original source](https://github.com/cloudant/swift-cloudant).

This framework will be maintained over the medium / long term, but only on a best-effort basis by enterprising IBMers who like the project and want to work on it in their free time. 

Please do not contact the [@Cloudant](https://github.com/cloudant) regarding this repository. Please also do not contact any previous maintainers. 
The cloudant team has no connection to this repository and cannot help or provide any support.

**Applications use swift-cloudant to store, index and query remote
JSON data on Cloudant or CouchDB.**

Swift-Cloudant is an [Apache CouchDB&trade;][acdb] client written in Swift. It
is built by [Cloudant](https://cloudant.com) and is available under the
[Apache 2.0 license][ap2].

[ap2]: https://github.com/cloudant/sync-android/blob/master/LICENSE
[acdb]: http://couchdb.apache.org/

## Early-Release

This is an early-release version of the library, with support for the following operations:

- Getting documents by doc ID.
- Updating and deleting documents.
- Creating and deleting databases.
- Changes Feed operations
- Creating, updating and deleting of attachments.
- Querying views.
- Creating, deleting and querying indexes.

We will be rounding out the feature set in upcoming releases.

**Currently it does not support being called from Objective-C.**

## Support

`SwiftCloudant` is supported, however since it is an early release it is
on a "best effort" basis.

### Platforms

Currently Swift Cloudant supports:

Swift versions
- Minimum Swift language version 4.2
- Minimum Swift tools version 5.0

Platforms
- macOS
- Linux

Swift Cloudant is unsupported on:

- iOS (should work, but hasn't been tested)
- tvOS
- watchOS

## Using in your project

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

Currently they are no third party dependencies.

## Contributors

See [CONTRIBUTORS](CONTRIBUTORS).

## Contributing to the project

See [CONTRIBUTING](CONTRIBUTING.md).

## License

See [LICENSE](LICENSE)
