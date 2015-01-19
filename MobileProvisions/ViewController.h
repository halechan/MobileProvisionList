//
//  ViewController.h
//  MobileProvisions
//
//  Created by Hale Chan on 15/1/19.
//  Copyright (c) 2015年 PapayaMobile Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (weak) IBOutlet NSOutlineView *outlineView;
@end

