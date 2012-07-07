//
//  ABContactsListView.m
//  Mystery
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ABContactsListView.h"

#import "ContactsListTableViewCell.h"

#import "ContactsListContainerView.h"

@implementation ABContactsListView

@synthesize allContactsInfoArrayInABRef = _allContactsInfoArrayInABRef;

@synthesize presentContactsInfoArrayRef = _presentContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // get all contacts info array from addressBook
        _allContactsInfoArrayInABRef = _presentContactsInfoArrayRef = [AddressBookManager shareAddressBookManager].allContactsInfoArray;
        
        // set table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // set view gesture recognizer delegate
        self.viewGestureRecognizerDelegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_presentContactsInfoArrayRef count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ContactsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // get contact bean 
    ContactBean *_contactBean = [_presentContactsInfoArrayRef objectAtIndex:indexPath.row];
    cell.photoImg = [UIImage imageWithData:_contactBean.photo];
    cell.displayName = _contactBean.displayName;
    cell.groupName = [_contactBean.groups toStringWithSeparator:@", "];
    cell.phoneNumbersArray = _contactBean.phoneNumbers;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at indexPath.
    return [ContactsListTableViewCell cellHeightWithContact:[_presentContactsInfoArrayRef objectAtIndex:indexPath.row]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // call parent view method:(void)hideSoftKeyboardWhenBeginScroll
    [((ContactsListContainerView *)self.superview) hideSoftKeyboardWhenBeginScroll];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@ - tableView: didSelectRowAtIndexPath: - tableView = %@ and indexPath = %@", NSStringFromClass(self.class), tableView, indexPath);
    
    //
}

- (LongPressFingerMode)longPressFingerModeInView:(UIView *)pView{
    return fourFingers;
}

- (void)view:(UIView *)pView longPressAtPoint:(CGPoint)pPoint andFingerMode:(LongPressFingerMode)pFingerMode{
    NSLog(@"%@ - view: longPressAtPoint: - view = %@, longPress at point = %@ and finger mode = %d", NSStringFromClass(self.class), pView, NSStringFromCGPoint(pPoint), pFingerMode);
    
    //
}

- (UISwipeGestureRecognizerDirection)swipeDirectionInView:(UIView *)pView{
    return UISwipeGestureRecognizerDirectionLeft;
}

- (void)view:(UIView *)pView swipeAtPoint:(CGPoint)pPoint andDirection:(UISwipeGestureRecognizerDirection)pDirection{
    NSLog(@"%@ - view: swipeAtPoint: - view = %@, swipe at point = %@ and dirextion = %d", NSStringFromClass(self.class), pView, NSStringFromCGPoint(pPoint), pDirection);
    
    //
}

- (TapFingerMode)tapFingerModeInView:(UIView *)pView{
    return single | doubleFingers;
}

- (TapCountMode)tapCountModeInView:(UIView *)pView{
    return twice;
}

- (void)view:(UIView *)pView tapAtPoint:(CGPoint)pPoint andFingerMode:(TapFingerMode)pFingerMode andCountMode:(TapCountMode)pCountMode{
    NSLog(@"%@ - view: tapAtPoint: - view = %@, tap at point = %@, finger mode = %d and count mode = %d", NSStringFromClass(self.class), pView, NSStringFromCGPoint(pPoint), pFingerMode, pCountMode);
    
    //
}

@end
