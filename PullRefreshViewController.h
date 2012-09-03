//
//  PullRefreshViewController.h (was: PullRefreshTableViewController.h)
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver (Modifications by JK Laiho)
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>


@interface PullRefreshViewController : UIViewController <UIScrollViewDelegate>

// Weak, because the table view this refers to should already be retained elsewhere.
// Run -setTableViewToRefresh: in your VC subclass, this will also set up the extra
// pull-to-refresh subviews on top of the existing table cells.
@property (weak, nonatomic) UITableView *tableViewToRefresh;

// Override -setupStrings to properly customize these strings
@property (copy, nonatomic) NSString *textPull;
@property (copy, nonatomic) NSString *textRelease;
@property (copy, nonatomic) NSString *textLoading;

- (void)setupStrings;

// Override for your actual refresh action
- (void)refresh;

// Remember to call this at the end of your -refresh implementation.
// Safe to call even if you're not currently in pull-to-refresh mode,
// which is useful for DRY code with other table refreshing mechanisms.
- (void)stopLoading;

@end
