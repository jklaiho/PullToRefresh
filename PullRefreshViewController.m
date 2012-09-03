//
//  PullRefreshViewController.m (was: PullRefreshTableViewController.m)
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

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface PullRefreshViewController ()

@property (retain, nonatomic) UIView *refreshHeaderView;
@property (retain, nonatomic) UILabel *refreshLabel;
@property (retain, nonatomic) UIImageView *refreshArrow;
@property (retain, nonatomic) UIActivityIndicatorView *refreshSpinner;

- (void)startLoading;

@end

@implementation PullRefreshViewController {
    BOOL isDraggingTableView;
    BOOL isLoadingNewItems;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupStrings];
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.refreshHeaderView = nil;
    self.refreshLabel = nil;
    self.refreshArrow = nil;
    self.refreshSpinner = nil;
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
}

- (void)setTableViewToRefresh:(UITableView *)tableViewToRefresh
{
    self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    self.refreshLabel.backgroundColor = [UIColor clearColor];
    self.refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.refreshLabel.textAlignment = UITextAlignmentCenter;
    
    self.refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    self.refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                         (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                         27, 44);
    
    self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    self.refreshSpinner.hidesWhenStopped = YES;
    
    [self.refreshHeaderView addSubview:self.refreshLabel];
    [self.refreshHeaderView addSubview:self.refreshArrow];
    [self.refreshHeaderView addSubview:self.refreshSpinner];
    
    _tableViewToRefresh = tableViewToRefresh;
    [_tableViewToRefresh addSubview:self.refreshHeaderView];
}

- (void)startLoading
{
    isLoadingNewItems = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewToRefresh.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        self.refreshLabel.text = self.textLoading;
        self.refreshArrow.hidden = YES;
        [self.refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
    if (!isLoadingNewItems) return;
    
    isLoadingNewItems = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3
                     animations:^{
        self.tableViewToRefresh.contentInset = UIEdgeInsetsZero;
        [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingComplete)];
    }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    self.refreshLabel.text = self.textPull;
    self.refreshArrow.hidden = NO;
    [self.refreshSpinner stopAnimating];
}

#pragma mark Overrideable methods

- (void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)setupStrings
{
    self.textPull = @"Pull down to refresh...";
    self.textRelease = @"Release to refresh...";
    self.textLoading = @"Loading...";
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.refreshHeaderView) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must run -setTableViewToRefresh: to enable pull-to-refresh" userInfo:nil];
    }
    if (isLoadingNewItems) return;
    isDraggingTableView = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.refreshHeaderView) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must run -setTableViewToRefresh: to enable pull-to-refresh" userInfo:nil];
    }
    if (isLoadingNewItems) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableViewToRefresh.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableViewToRefresh.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDraggingTableView && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                self.refreshLabel.text = self.textRelease;
                [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                self.refreshLabel.text = self.textPull;
                [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.refreshHeaderView) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must run -setTableViewToRefresh: to enable pull-to-refresh" userInfo:nil];
    }
    if (isLoadingNewItems) return;
    isDraggingTableView = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

@end
