//
//  MobileProvisionParser.m
//  MobileProvisionList
//
//  Created by Hale Chan on 15/1/19.
//  Copyright (c) 2015年 PapayaMobile Inc. All rights reserved.
//

#import "MobileProvisionParser.h"

static NSString *kProvisionKeyAppIDName = @"AppIDName";
static NSString *kProvisionKeyApplicationIdentifierPrefix = @"ApplicationIdentifierPrefix";
static NSString *kProvisionKeyCreationDate = @"CreationDate";
static NSString *kProvisionKeyDeveloperCertificates = @"DeveloperCertificates";
static NSString *kProvisionKeyEntitlements = @"Entitlements";
static NSString *kProvisionKeyExpirationDate = @"ExpirationDate";
static NSString *kProvisionKeyName = @"Name";
static NSString *kProvisionKeyProvisionedDevices = @"ProvisionedDevices";
static NSString *kProvisionKeyTeam = @"Team";
static NSString *kProvisionKeyTeamIdentifier = @"TeamIdentifier";
static NSString *kProvisionKeyTeamName = @"TeamName";
static NSString *kProvisionKeyTimeToLive = @"TimeToLive";
static NSString *kProvisionKeyUUID = @"UUID";
static NSString *kProvisionKeyVersion = @"Version";

NSDictionary *dumpProvisonFromFileAtPath(NSString *filePath)
{
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSString *startString = @"<?xml version";
        NSString *endString = @"</plist>";
        
        NSData *rawData = [NSData dataWithContentsOfFile:filePath];
        NSData *startData = [NSData dataWithBytes:[startString UTF8String] length:startString.length];
        NSData *endData = [NSData dataWithBytes:[endString UTF8String] length:endString.length];
        
        NSRange fullRange = {.location = 0, .length = [rawData length]};
        
        NSRange startRange = [rawData rangeOfData:startData options:0 range:fullRange];
        NSRange endRange = [rawData rangeOfData:endData options:0 range:fullRange];
        
        NSRange plistRange = {.location = startRange.location, .length = endRange.location + endRange.length - startRange.location};
        NSData *plistData = [rawData subdataWithRange:plistRange];
        
        id obj = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:NULL error:nil];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return obj;
        }
    }
    return nil;
}

NSDictionary *allMobileProvisions()
{
    NSString *defaultPath = [NSString stringWithFormat:@"%@/Library/MobileDevice/Provisioning Profiles/", NSHomeDirectory()];
    
    NSMutableDictionary *provisions = [NSMutableDictionary dictionary];
    
    NSArray *pathItems = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:defaultPath error:nil];
    for (NSString *fileName in pathItems) {
        if ([[fileName pathExtension] isEqualToString:@"mobileprovision"]) {
            NSString *fullPath = [defaultPath stringByAppendingPathComponent:fileName];
            NSDictionary *info = dumpProvisonFromFileAtPath(fullPath);
            NSString *uuid = info[kProvisionKeyUUID];
            if (info && uuid.length) {
                provisions[uuid] = info;
            }
        }
    }
    
    return provisions.count ? [NSDictionary dictionaryWithDictionary:provisions] : nil;
}