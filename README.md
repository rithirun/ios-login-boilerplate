# iOS REST Login Boilerplate #

A simple iOS app designed to login and registration to a rails (or other RESTful) app. This app is intended to be a starting point for building your REST-enabled, user authentication based application.

## Features

 * Simple, DRY implementation of REST/JSON functionality at the model level
 * Serializable object (which extends NSObject) which can be used as the base for every RESTful object in your app
 * Universal approach to application controller architecture through NavigationController
 * Connectivity provided by the [ASIHTTPRequest library](https://github.com/pokeb/asi-http-request)
 * JSON translation provided by the [SBJson library](http://stig.github.com/json-framework/)
 * Utility classes for things like inflection and error handling from the server
 * User persistence through a simple "Remember Me" switch (stored in a plist)
 
## Assumptions

This application assumes the following from a REST architecture standpoint:

 * Your login/authentication functionality will be a REST POST
 * Your application models can be translated directly into JSON objects
 
## Application Components

 * The AppUser model (The User that is being logged in or registered)
 * Controllers for Login and Registration
 * A "Home" controller, where the user will land after login or registration
 * A SerializableObject class (extended by each RESTful object, such as AppUser)
 
The SerializableObject class contains two important properties which much be implemented in the subclasses init method:

 * objectName: A REST name for the model. For instance, AppUser's objectName is "user", which will be used to create the JSON ({ "user": { ... }})
 * serializableProperties: An NSDictionary which maps internal properties to their JSON counterparts (internal_property => json_property). For instance, AppUser translates userId to id. Keys with empty strings will send the internal property name (like password => password)
 
## Disclaimer

Since this is my first major iOS development project, this application may be subject to bugs or memory leaks. Since I will be using this for many applications, I will make every attempt to squash these as quickly as possible. Forks and pull requests are greatly encouraged, both from a project health standpoint, but also because it will provide much needed education for me personally.

## LICENSE

See the LICENSE file.