//
//  GlobalData.h
//  InYuan
//
//  Created by Lance on 2019/2/5.
//  Copyright © 2019 Lance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHelper.h"
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalData : NSObject

+ (instancetype)sharedManager;

//DatabaseHelper
@property (nonatomic, strong) DatabaseHelper *dbHelper;
@property (nonatomic, strong) FMDatabase *database;

//是否長按Tabbar進入遙控器模式
@property (nonatomic, assign, readwrite) BOOL remoteMode;
// selectedItem for SongBook VC
@property (nonatomic, assign, readwrite) NSInteger menu1Selected;
@property (nonatomic, assign, readwrite) NSInteger menu2Selected;

//SongBook Menu1
@property (nonatomic, strong) NSArray *menu1Array;
//SongBook Menu2
@property (nonatomic, strong) NSArray *menu2Array;
//SongBook resultArray
@property (nonatomic, strong) NSArray *resultArray;

@end

NS_ASSUME_NONNULL_END
