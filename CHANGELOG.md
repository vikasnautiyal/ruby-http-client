# Change Log
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/).

## [2.1.2] - 2016-06-14
### Fix
- Typo in 2.1.1 fix

## [2.1.1] - 2016-06-10
### Fix
- Deal with an edge case where when you send a POST with no body, net/http sets the content type to application/x-www-form-urlencoded

## [2.1.0] - 2016-06-10
### Added
- Automatically add Content-Type: application/json when there is a request body

## [2.0.0] - 2016-06-03
### Changed
- Made the Response variables non-redundant. e.g. response.response_body becomes response.body

### Removed
- Config class

## [1.1.0] - 2016-03-17
### Added
- Config class moved to client

## [1.0.0] - 2016-03-17
### Added
- We are live!