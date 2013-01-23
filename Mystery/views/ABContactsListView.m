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

// phonetics indication string
#define PHONETICSINDIACATION_STRING  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@implementation ABContactsListView

@synthesize allContactsInfoArrayInABRef = _allContactsInfoArrayInABRef;

@synthesize presentContactsInfoArrayRef = _presentContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // get all contacts info array from addressBook
        _allContactsInfoArrayInABRef = _presentContactsInfoArrayRef = [[AddressBookManager shareAddressBookManager].allContactsInfoArray optPhoneticsSortedContactsInfoArray];
        
        // set table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // set view gesture recognizer delegate
        self.viewGestureRecognizerDelegate = self;
        
        // add addressBook changed observer
        [[AddressBookManager shareAddressBookManager] addABChangedObserver:self];
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
    cell.uniqueIdentifier = _contactBean.id;
    cell.photoImg = [UIImage imageWithData:_contactBean.photo];
    cell.displayName = _contactBean.displayName;
    cell.fullNames = _contactBean.fullNames;
    cell.groupName = [_contactBean.groups toStringWithSeparator:@", "];
    cell.phoneNumbersArray = _contactBean.phoneNumbers;
    cell.phoneNumberMatchingIndexs = [_contactBean.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS];
    cell.nameMatchingIndexs = [_contactBean.extensionDic objectForKey:NAME_MATCHING_INDEXS];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // define phonetics indication string array
    NSMutableSet *_indices = [[NSMutableSet alloc] init];
    
    // process present contacts info array
    for (ContactBean *_contact in _presentContactsInfoArrayRef) {
        // contact has name
        if ([_contact.namePhonetics count] > 0) {
            [_indices addObject:[[[[_contact.namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] uppercaseString]];
        }
        // contact has no name
        else {
            [_indices addObject:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]];
        }
    }
    
    return [[_indices allObjects] sortedArrayUsingComparator:^(NSString *_string1, NSString *_string2){
        NSComparisonResult _stringComparisonResult = NSOrderedSame;
        
        // compare
        if ([_string1 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedDescending;
        }
        else if ([_string2 isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            _stringComparisonResult = NSOrderedAscending;
        }
        else {
            _stringComparisonResult = [_string1 compare:_string2];
        }
        
        return _stringComparisonResult;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    // process procent contacts info array
    for (NSInteger _index = 0; _index < [_presentContactsInfoArrayRef count]; _index++) {
        // 26 chars, 'ABCD...XYZ'
        if (![[title lowercaseString] isEqualToString:[PHONETICSINDIACATION_STRING substringFromIndex:[PHONETICSINDIACATION_STRING length] - 1]]) {
            // contact has name
            if ([((ContactBean *)[_presentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] > 0) {
                // get the matching contacts header
                if ([[[[((ContactBean *)[_presentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics objectAtIndex:0] objectAtIndex:0] substringToIndex:1] compare:[title lowercaseString]] >= NSOrderedSame) {
                    // scroll to row at indexPath
                    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            
                    break;
                }
            }
            // contact has no name
            else {
                // scroll to row at indexPath
                [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                break;
            }
        }
        // '#'
        else {
            // contact has no name
            if ([((ContactBean *)[_presentContactsInfoArrayRef objectAtIndex:_index]).namePhonetics count] == 0) {
                // scroll to row at indexPath
                [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                break;
            }
        }
    }
    
    // default value
    return -1;
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

- (GestureType)supportedGestureInView:(UIView *)pView{
    return tap | longPress | swipe;
}

- (LongPressFingerMode)longPressFingerModeInView:(UIView *)pView{
    return doubleFingers;
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

- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver{
    // reset all contacts info array from addressBook and present contacts info array of addressBook contacts list table view
    NSArray *_newAllContactsInfoArrayInAB = [[AddressBookManager shareAddressBookManager].allContactsInfoArray phoneticsSortedContactsInfoArray];
    
    // get addressBook contacts list table view parent view
    ContactsListContainerView *_contactsSelectContainerView = (ContactsListContainerView *)self.superview;
    
    // process changed contact id array
    for (NSNumber *_contactId in [pInfo allKeys]) {
        // get action
        switch (((NSNumber *)[[pInfo objectForKey:_contactId] objectForKey:CONTACT_ACTION]).intValue) {
            case contactAdd:
            {
                // add to all contacts info array in addressBook reference
                for (NSInteger _index = 0; _index < [_newAllContactsInfoArrayInAB count]; _index++) {
                    if (((ContactBean *)[_newAllContactsInfoArrayInAB objectAtIndex:_index]).id == _contactId.integerValue) {
                        [_allContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_index] atIndex:_index];
                        
                        [_contactsSelectContainerView searchContactWithParameter];
                        
                        break;
                    }
                }
            }
                break;
                
            case contactModify:
            {
                // save the modify contact index of all contacts info array in addressBook reference and new temp all contacts info array in addressBook
                NSInteger _oldindex, _newIndex;
                for (NSInteger _index = 0; _index < [_allContactsInfoArrayInABRef count]; _index++) {
                    if (((ContactBean *)[_allContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
                        _oldindex = _index;
                        
                        _newIndex = [_newAllContactsInfoArrayInAB indexOfObject:[_allContactsInfoArrayInABRef objectAtIndex:_index]];
                        
                        break;
                    }
                }
                
                // check the two indices
                if (_oldindex != _newIndex) {
                    [_allContactsInfoArrayInABRef removeObjectAtIndex:_oldindex];
                    [_allContactsInfoArrayInABRef insertObject:[_newAllContactsInfoArrayInAB objectAtIndex:_newIndex] atIndex:_newIndex];
                }
                
                [_contactsSelectContainerView searchContactWithParameter];
            }
                break;
                
            case contactDelete:
            {
                // delete from all contacts info array in addressBook reference
                for (NSInteger _index = 0; _index < [_allContactsInfoArrayInABRef count]; _index++) {
                    if (((ContactBean *)[_allContactsInfoArrayInABRef objectAtIndex:_index]).id == _contactId.integerValue) {
                        [_allContactsInfoArrayInABRef removeObjectAtIndex:_index];
                        
                        [_contactsSelectContainerView searchContactWithParameter];
                        
                        break;
                    }
                }
            }
                break;
        }
    }
}

@end
