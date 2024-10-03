# ByVids
### Overview
Welcome to the ByVids App! 

This iOS application serves as assessment for ByThen.

## Implementation Details
### Network Layer
The application follows a structured network layer with the following components:

1. NetworkProvider: Handles making requests and returning responses as data or failures in the form of NetworkError.
2. NetworkError: Error for network request and customized description.
3. NetworkProvider+Extension: Provide `endpointClosure` and `requestClosure` for `MoyaProvider`

### Architecture
The app follows the MVVM design pattern with Coordinator and Clean Architecture 

```
- Application
     - Infrastructure
          - Networking
               - NetworkProvider
               - NetworkError
               - NetworkProvider+Extension
     - Data
          - Repository Implementations
          - TargetTypes
          - DataSourceFactory
     - Domain 
          - Repository
          - Model / Entities
     - Presentation 
          - Components
          - Coordinator
          - Extensions
          - Scene
               - ViewModel
               - View

```

This folder structure organizes the application into clear sections, making it easier for developers to navigate and understand the codebase.

## Getting Started
To start the project, simply open the file TerraWeather.xcodeproj.

## Preview

![iOS](./demo.gif)
