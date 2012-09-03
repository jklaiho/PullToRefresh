# PullToRefresh

A simple iPhone view controller for adding pull-to-refresh functionality.
Modified from Leah Culver's original by JK Laiho.

This fork requires Xcode >= 4.4 (automatic property synthesizing) and iOS >= 5 (ARC).

## Fork highlights

* Supports (and requires the use of) Automatic Reference Counting.
* No longer a UITableViewController subclass, but instead a UIViewController
  \<UIScrollViewDelegate\>. Use it in any view controller with a UITableView!
* Code modernized and cleaned up.

![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-1.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-2.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-3.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-4.png)

Inspired by [Tweetie 2](http://www.atebits.com/tweetie-iphone/), [Oliver Drobnik's blog post](http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/)
and [EGOTableViewPullRefresh](http://github.com/enormego/EGOTableViewPullRefresh).


## Installation

1. Copy PullRefreshTableViewController.h, PullRefreshTableViewController.m and arrow.png into your project.

2. Link against the QuartzCore framework (used for rotating the arrow image).

3. Create a view controller that is a subclass of PullRefreshViewController.

4. Run `[self setTableViewToRefresh:aTableView]` on the UITableView for which you
wish to enable pull-to-refresh. This is probably best done in your `-viewDidLoad`
method. Failure to do this will raise an exception when scrolling the table view.

5. If your view controller subclass implements any of the following
UIScrollViewDelegate methods, be sure to call `[super nameOfMethod]` in your implementations:
  * `-scrollViewDidBeginDragging:`
  * `-scrollViewDidScroll:`
  * `-scrollViewDidEndDragging:`

6. Implement the actual refresh functionality by overriding the `-refresh`
method.

7. (optional) Customize the refresh arrow by using a different arrow.png file
(try and keep the same image file dimensions). Customize the strings shown
in the pulled-down view by overriding `-setupStrings`

Enjoy!
