# tmdb

Simple proof of concept for a movie based application

### About the code base

#### Architecture 
The architecture is MVVM with dependency injection and protocol based class implementations. I used the [coordinator pattern](https://www.swiftbysundell.com/posts/navigation-in-swift) to handle all my navigational logic to further decouple the responsibilites of the view controllers. 

This makes the code testable and reduces code smell. 

I prefer writing all my views programmatically for several reasons. There is no secondary truth of how something will look or behave in a nib or a storyboard. It makes collaborating as a team easier since storyboards used by several people at the same time causes merge conflicts in git.

#### Installation
```
git clone -b git@github.com:patrikqvarnstrom/tmdb.git
```

#### Features

- View a list of upcoming movies
  - Display poster, title, genres and release date
  - Sorted in latest release order
- Detail view for movie
- Search for a movie
- Guest session authentication

#### Third party dependencies (pods)

- Alamofire as the networking library
- Lottie for animations
- SnapKit for lightweight syntax working with constraints
- SDWebImage for asynchronous image download
