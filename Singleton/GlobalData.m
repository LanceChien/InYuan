//
//  GlobalData.m
//  InYuan
//
//  Created by Lance on 2019/2/5.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "GlobalData.h"

@interface GlobalData()

@property (nonatomic, strong) NSArray *menu2Array0;
@property (nonatomic, strong) NSArray *menu2Array1;
@property (nonatomic, strong) NSArray *menu2Array2;
@property (nonatomic, strong) NSArray *menu2Array3;
@property (nonatomic, strong) NSArray *menu2Array4;
@property (nonatomic, strong) NSArray *menu2Array5;
@property (nonatomic, strong) NSArray *menu2Array6;
@property (nonatomic, strong) NSArray *menu2Array7;
@property (nonatomic, strong) NSArray *menu2Array8;
@property (nonatomic, strong) NSArray *menu2Array9;
@property (nonatomic, strong) NSArray *menu2Array10;
@property (nonatomic, strong) NSArray *menu2Array11;
@property (nonatomic, strong) NSArray *menu2Array12;
@property (nonatomic, strong) NSArray *menu2Array13;
@property (nonatomic, strong) NSArray *menu2Array14;
@property (nonatomic, strong) NSArray *menu2Array15;
@property (nonatomic, strong) NSArray *menu2Array16;

@end


@implementation GlobalData

static GlobalData *_instance = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _instance = [[self alloc] initPrivate];
    });
    return _instance;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"..." userInfo:nil];
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        _dbHelper=[DatabaseHelper new];
        _database=[FMDatabase new];
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"InYuan.db"];
        _database = [FMDatabase databaseWithPath:dbPath];
        
        _menu1Array=[NSArray arrayWithObjects:@"語言",@"我的K房",@"音圓之星",@"歌手",@"最新",@"常唱",@"對唱",@"經典懷舊",@"音域選歌",@"熱歌勁舞",@"情境",@"節奏",@"大陸歌曲",@"會場歌曲",@"其他",@"音樂欣賞",@"影音收藏",nil];
        [self setupMenu2Array];
        _resultArray=[NSArray new];
    }
    return self;
}
-(void)setupMenu2Array{
    NSMutableArray *tempArray=[NSMutableArray new];
    _menu2Array0=[NSArray arrayWithObjects:@"國語",@"台語",@"客語",@"粵語",@"英文",@"日文",@"韓文",@"泰文",@"越文", nil];
    [tempArray addObject:_menu2Array0];
    _menu2Array1=[NSArray arrayWithObjects:@"", nil];
    [tempArray addObject:_menu2Array1];
    _menu2Array2=[NSArray arrayWithObjects:@"音圓歌手",@"音圓歌曲", nil];
    [tempArray addObject:_menu2Array2];
    _menu2Array3=[NSArray arrayWithObjects:@"華語男",@"華語女",@"華語團體",@"外語男",@"外語女",@"外語團體", nil];
    [tempArray addObject:_menu2Array3];
    _menu2Array4=[NSArray arrayWithObjects:@"國語",@"台語",@"客語",@"粵語",@"英文",@"日文",@"韓文",@"泰文",@"越文", nil];
    [tempArray addObject:_menu2Array4];
    _menu2Array5=[NSArray arrayWithObjects:@"國語推薦",@"國語累計",@"台語推薦",@"台語累計",@"粵語推薦",@"粵語累計",@"英文推薦",@"英文累計",@"日文推薦",@"日文累計", nil];
    [tempArray addObject:_menu2Array5];
    _menu2Array6=[NSArray arrayWithObjects:@"國語",@"台語",@"粵語",@"英文",@"日文", nil];
    [tempArray addObject:_menu2Array6];
    _menu2Array7=[NSArray arrayWithObjects:@"國語經典",@"台語經典",@"民歌年代",@"台灣歌謠",@"西洋經典",@"東洋經典", nil];
    [tempArray addObject:_menu2Array7];
    _menu2Array8=[NSArray arrayWithObjects:@"國語",@"台語",@"粵語",nil];
    [tempArray addObject:_menu2Array8];
    _menu2Array9=[NSArray arrayWithObjects:@"國語",@"台語",@"粵語",@"英文",@"日文", nil];
    [tempArray addObject:_menu2Array9];
    _menu2Array10=[NSArray arrayWithObjects:@"友情不渝 ",@"愛情萬歲",@"失戀悲歌",@"勵志向上",@"感嘆人生",@"酒場文化",nil];
    [tempArray addObject:_menu2Array10];
    _menu2Array11=[NSArray arrayWithObjects:@"Slow",@"Slow Soul",@"Slow Rock",@"Soft Rock",@"Soul",@"Waltz",@"Trot",@"Jitterbug",@"Slow Swing",@"Swing",@"Tango",@"Rumba",@"Cha-Cha",@"Slow Disco",@"Disco",@"Rock",@"Twist",@"Samba",@"Quick Waltz",@"Shuffle",@"Reggae",@"R&B",@"Hip-Hop",@"Funk",@"Bossa Nova",@"House",@"Techno",nil];
    [tempArray addObject:_menu2Array11];
    _menu2Array12=[NSArray arrayWithObjects:@"", nil];
    [tempArray addObject:_menu2Array12];
    _menu2Array13=[NSArray arrayWithObjects:@"", nil];
    [tempArray addObject:_menu2Array13];
    _menu2Array14=[NSArray arrayWithObjects:@"兒童歌謠",@"山地歌曲",@"節慶歌曲",@"東方宗教",@"西方宗教",nil];
    [tempArray addObject:_menu2Array14];
    _menu2Array15=[NSArray arrayWithObjects:@"古典音樂",@"抒情音樂",@"熱門音樂",@"綜合音樂",nil];
    [tempArray addObject:_menu2Array15];
    _menu2Array16=[NSArray arrayWithObjects:@"影音歌曲",@"MP3/LRC", nil];
    [tempArray addObject:_menu2Array16];
    _menu2Array=[NSArray arrayWithArray:tempArray];
}


@end
