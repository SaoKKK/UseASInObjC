//
//  AppDelegate.m
//  UseASInObjC
//
//  Created by 河野 さおり on 2015/03/23.
//  Copyright (c) 2015年 Saori Kohno. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSAppleEventDescriptor*)GetAEDesc:(NSString*)ASName{
    NSDictionary *asErrDic;
    NSString *asPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:ASName];
    NSURL *url = [NSURL fileURLWithPath:asPath];
    NSAppleScript *as = [[NSAppleScript alloc]initWithContentsOfURL:url error:&asErrDic];
    
    if (asErrDic) {
        //エラー処理
    }
    NSLog (@"%@",[as executeAndReturnError:&asErrDic]);
    return [as executeAndReturnError:&asErrDic];
}

- (IBAction)GetStringRV:(id)sender {
    NSAppleEventDescriptor *aeDesc = [self GetAEDesc:@"test_str.scpt"];
    NSLog(@"%@",[aeDesc stringValue]);
}

- (IBAction)GetIntegerRV:(id)sender {
    NSAppleEventDescriptor *aeDesc = [self GetAEDesc:@"test_int.scpt"];
    NSLog(@"%i",[aeDesc int32Value]);
}

- (IBAction)GetListRV:(id)sender {
    NSMutableArray *array = [NSMutableArray array];
    NSAppleEventDescriptor *aeDesc = [self GetAEDesc:@"test_list.scpt"];
    NSInteger CntItems = [aeDesc numberOfItems];
    for (NSInteger i = 1; i <= CntItems; i++) {
        [array addObject:[[aeDesc descriptorAtIndex:i]stringValue]];
    }
    NSLog(@"%@",array);
}

- (IBAction)GetRecordRV:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSAppleEventDescriptor *aeDesc = [self GetAEDesc:@"test_rec.scpt"];
    [dict setObject:[[aeDesc descriptorForKeyword:'pnam']stringValue] forKey:@"name"];
    NSAppleEventDescriptor *valParam = [aeDesc descriptorForKeyword:'usrf'];
    NSString *name = nil;
    NSString *param = nil;
    NSInteger CntParam = [valParam numberOfItems];
    for (NSInteger i = 1; i <= CntParam; i++) {
        NSAppleEventDescriptor *val = [valParam descriptorAtIndex:i];
        NSString *str = [val stringValue];
        if (name) {
            [dict setObject:str forKey:name];
            name = nil;
            param = nil;
        }else{
            name = str;
        }
    }
    NSLog(@"%@",dict);
}

@end
