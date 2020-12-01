#  Giphy Sample App

# Introduction
Giphy Sample app is Tab Bar application. First Tab shows the list of Gifs fetched from Giphy API. Second Tab shows
the favorite gifs stored in the local database

**Feature List**
- Showing gifs in the list view
- User can mark favorite any gif by clicking on the favorite gif
- User can mark unfavorite which is already added as favorite gif


## Third Party Libs used
1. Giphy - used to fetch gifs. Two api endpoint used (Trending and Search)
2. FLAnimatedImage - used to show the gifs on the image view
3. RxGRDB - For local database
4. RxSwift - For reactive programming i.e  to bind data with table view and collection view
5. Quick - For writing Test cases
6. Nimble - For writing Test cases

### Storyboard is used to create the UI Screens

## Models
- GifModel
- GiphyAPIRequestModel

## API Usage

### To fetch data from Giphy API

```swift
    private let gifViewModel = GifViewModel()
    gifViewModel.fetchTredingGifs()
    gifViewModel.fetchSearchGifs(query: userQuery)
```

### To Save data into Local Database

```swift
    private let model = GifModel()
    GSDBManager.sharedGifDBManager.getGifDao().insert(obj: model)
```
### To Retrieve data from Local Database
 It will return the observable<[GifModels]>. User need to subscribe to get the data.
```swift
    let gifsObservable = gifViewModel.fetchSavedGifs()
```
### To delete data from Local Database
```swift
    GSDBManager.sharedGifDBManager.getGifDao().deleteGifById(id: [Need to pass model id property])
```
### Test Coverage is 67%

### Improvements
1. pagination - Table view prefetch DataSource protocol can be used to implement pagination
2. Refresh Table view
