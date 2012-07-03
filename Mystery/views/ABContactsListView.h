//
//  ABContactsListView.h
//  Mystery
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

@interface ABContactsListView : UITableView <UITableViewDataSource, UITableViewDelegate, UIViewGestureRecognizerDelegate>

// all contacts info array in addressBook reference
@property (nonatomic, readonly) NSArray *allContactsInfoArrayInABRef;

// present contacts info array reference
@property (nonatomic, retain) NSMutableArray *presentContactsInfoArrayRef;

@end
