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

- (void)view:(UIView *)pView longPressAtPoint:(CGPoint)pPoint{
    NSLog(@"%@ - view: longPressAtPoint: - view = %@ and longPress at point = %@", NSStringFromClass(self.class), pView, NSStringFromCGPoint(pPoint));
    
    //
}

- (void)view:(UIView *)pView swipeAtPoint:(CGPoint)pPoint{
    NSLog(@"%@ - view: swipeAtPoint: - view = %@ and swipe at point = %@", NSStringFromClass(self.class), pView, NSStringFromCGPoint(pPoint));
    
    //
}

@end
