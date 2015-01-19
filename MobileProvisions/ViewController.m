//
//  ViewController.m
//  MobileProvisions
//
//  Created by Hale Chan on 15/1/19.
//  Copyright (c) 2015年 PapayaMobile Inc. All rights reserved.
//

#import "ViewController.h"
#import "MobileProvisionParser.h"


@interface TreeNode : NSObject

@property (nonatomic, weak)TreeNode *parentNode;
@property (nonatomic, strong)NSArray *childrenNodes;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *notes;
@property (nonatomic, copy)NSString *type;

- (id)initWithParentNode:(TreeNode *)parentNote originInfo:(id)info;

@end


@interface ViewController() {
    TreeNode *_rootNode;
}

@end

@implementation TreeNode

- (id)initWithParentNode:(TreeNode *)parentNote originInfo:(id)info
{
    self = [super init];
    if (self) {
        _parentNode = parentNote;
        
        if ([info isKindOfClass:[NSDictionary class]]) {
            _type = @"Dictionary";
            
            NSMutableArray *children = [NSMutableArray array];
            NSDictionary *dict = info;
            _notes = [NSString stringWithFormat:@"%lu items", (unsigned long)[dict count]];
            
            for (NSString *key in dict) {
                TreeNode *child = [[TreeNode alloc]initWithParentNode:self originInfo:dict[key]];
                child.title = key;
                [children addObject:child];
            }
            _childrenNodes = [NSArray arrayWithArray:children];
        }
        else if([info isKindOfClass:[NSArray class]]) {
            _type = @"Array";
            
            NSMutableArray *children = [NSMutableArray array];
            NSArray *array = info;
            _notes = [NSString stringWithFormat:@"%lu items", (unsigned long)[array count]];
            
            for (int i=0; i<[array count]; i++) {
                TreeNode *child = [[TreeNode alloc]initWithParentNode:self originInfo:array[i]];
                child.title = [NSString stringWithFormat:@"%d", i];
                [children addObject:child];
            }
            _childrenNodes = [NSArray arrayWithArray:children];
        }
        else {
            _notes = [NSString stringWithFormat:@"%@", info];
            
            if ([info isKindOfClass:[NSString class]]) {
                _type = @"String";
            }
            else if([info isKindOfClass:[NSDate class]]){
                _type = @"Date";
            }
            else if([info isKindOfClass:[NSNumber class]]) {
                _type = @"Number";
            }
            else {
                _type = @"Data";
            }
        }
        
        if (!parentNote) {
            _title = @"Root";
        }
    }
    
    return self;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *info = allMobileProvisions();
    TreeNode *node = [[TreeNode alloc]initWithParentNode:nil originInfo:info];
    node.title = @"Mobile Provisions";
    _rootNode = node;
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Outline

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    TreeNode *realItem = item ?: _rootNode;
    return [realItem.childrenNodes count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    TreeNode *realItem = item ?: _rootNode;
    return realItem.childrenNodes != nil;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    TreeNode *realItem = item ?: _rootNode;
    return realItem.childrenNodes[index];
}



- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    TreeNode *realItem = item ?: _rootNode;
    
    static NSString *kColumnIdentifierTitle = @"title";
    static NSString *kColumnIdentifierType = @"type";
    static NSString *kColumnIdentifierValue = @"notes";
    
    if ([[tableColumn identifier] isEqualToString:kColumnIdentifierTitle]) {
        return realItem.title;
    }
    else if([[tableColumn identifier] isEqualToString:kColumnIdentifierType]){
        return realItem.type;
    }
    else {
        return realItem.notes;
    }
}

@end
