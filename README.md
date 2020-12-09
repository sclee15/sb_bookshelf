# A Bookshelf app

A bookshelf app that talks with https://api.itbook.store


## Components

* ApiEndpoint
Allow change host endpoint easily by switching main files
* SearchApi
Actual communication logic
* Entities (PODO)
Book, BookDetail, SearchResults, and etc..
* Pages
DetailBookPage, SearchPage
* Store
A custom Bloc Pattern for SearchPage
* Cache
CacheImageFile - a future based image cache helper
CacheMap - a Isolate based Map Persistnace Storage
* Dependency Injection
DI
* GenTry
General retrying wrapper