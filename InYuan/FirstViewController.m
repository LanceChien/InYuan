//
//  FirstViewController.m
//  InYuan
//
//  Created by Lance on 2019/1/28.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "FirstViewController.h"
#import "SongItem.h"
#import "FMDB.h"
#import "UserItem.h"
#import "DatabaseHelper.h"
#import "KRoomItem.h"
#import "SongQueueListItem.h"

@interface FirstViewController ()
@property NSString *remainingString;

@end

@implementation FirstViewController

- (void)viewDidLoad {

}
-(void)viewWillAppear:(BOOL)animated{
    //SongItem *song=[SongItem new];
    
    /* 以下驗證Database Search Function */
    /*
    //曲號選歌
    song=[dbHelper searchByID:@"1004"];
    NSLog(@"sID:%@,namme:%@,singer:%@",song.sID,song.name,song.singer);
    NSLog(@"\n");
    
    //語言選歌Level2 :@"語言代碼"  (C：國語,CN：大陸,T：台語,K：客語,GD：粵語,E：英文,J：日文,KR：韓文,TH：泰文,VN：越文)
    resultArray=[dbHelper searchByLang:@"" andWord:@"" andBegin:0 andCount:0];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSLog(@"語言 %@",[resultArray objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    //語言選歌Level3 :@"語言代碼"  (C：國語,CN：大陸,T：台語,K：客語,GD：粵語,E：英文,J：日文,KR：韓文,TH：泰文,VN：越文)
    resultArray=[dbHelper searchByLang:@"C" andWord:@"9" andBegin:@"3" andCount:@"30"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *song=[resultArray objectAtIndex:i];
        NSLog(@"語言:%@,字部:%@ sID:%@,name:%@,singer:%@",song.lang,song.word,song.sID,song.name,song.singer);
    }
    NSLog(@"\n");
    */
    DatabaseHelper *dbHelper=[DatabaseHelper new];
    NSArray *resultArray=[NSArray array];
    
    //新增使用者到K房
    [dbHelper addUserToKRoom:@"John"];
    [dbHelper addUserToKRoom:@"王三"];
    [dbHelper addUserToKRoom:@"李四端"];
    [dbHelper addUserToKRoom:@"Kelly"];
    [dbHelper addUserToKRoom:@"Kelly"];
    [dbHelper addUserToKRoom:@"王三"];
    //列出K房所有User
    resultArray=[dbHelper searchAllUser];
    for (int i=0; i<[resultArray count]; i++) {
        NSString *user=[resultArray objectAtIndex:i];
        NSLog(@"列出所有User: %@",user);
    }
    
    //新增最愛歌曲到某個User的K房, type:1 user 3 favorite 4 recorded audio 5 recorded video
    KRoomItem *kItem=[KRoomItem new];
    kItem.userName=@"Kelly";
    kItem.sID=@"41883";
    kItem.icon=@"10";
    kItem.key=@"0";
    kItem.tone=@"F";
    kItem.type=@"3";
    kItem.songType=@"10";
    [dbHelper addToKRoom:kItem];
    kItem.userName=@"Kelly";
    kItem.sID=@"704";
    kItem.icon=@"10";
    kItem.key=@"0";
    kItem.tone=@"F";
    kItem.type=@"3";
    kItem.songType=@"10";
    [dbHelper addToKRoom:kItem];
    kItem.userName=@"John";
    kItem.sID=@"7103";
    kItem.icon=@"10";
    kItem.key=@"0";
    kItem.tone=@"F";
    kItem.type=@"3";
    kItem.songType=@"10";
    [dbHelper addToKRoom:kItem];
    
    //列出我的K房中的最愛歌曲
    resultArray=[dbHelper searchByKRoom:@"Kelly" andType:@"3"];
    for (int i=0; i<[resultArray count]; i++) {
        KRoomItem *kItem=[resultArray objectAtIndex:i];
        NSLog(@"%@的K房, sID:%@, 歌名:%@",kItem.userName,kItem.sID,kItem.name);
    }
    NSLog(@"\n");
    
    
    /*
    //列出音圓之星
    resultArray=[dbHelper searchIYStar];
    for (int i=0; i<[resultArray count]; i++) {
        NSString *star=[resultArray objectAtIndex:i];
        NSLog(@"IYsinger:%@",star);
    }
    //列出音圓歌曲
    
    resultArray=[dbHelper searchIYSong];
    for (int i=0; i<=resultArray.count-1; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"IY歌曲：ID:%@ IYStar=%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.sID,sItem.IYStar,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    
    //列出歌手Level2
    resultArray=[dbHelper searchSinger:@"" andGender:@""];
    for (int i=0; i<[resultArray count]; i++) {
        NSString *user=[resultArray objectAtIndex:i];
        NSLog(@"列出歌手Level2:%@",user);
    }
    
    //列出歌手Level3
    resultArray=[dbHelper searchSinger:@"C" andGender:@"4"];
    for (int i=0; i<[resultArray count]; i++) {
        NSString *singer=[resultArray objectAtIndex:i];
        NSLog(@"列出華語團體歌手:%@",singer);
    }
    
    //最新歌曲
    //尚未實作
    //常唱歌曲
    //尚未實作
    
    //對唱 Level2
    resultArray=[dbHelper searchByDuet:@""];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *lang=[resultArray objectAtIndex:i];
        NSLog(@"對唱Level2:%@",lang);
    }
    NSLog(@"\n");
    
    //對唱 Level3
    resultArray=[dbHelper searchByDuet:@"T"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"台語對唱歌曲：ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    NSLog(@"\n");
    //經典懷舊, if @"" 輸出 Level2
    resultArray=[dbHelper searchByNost:@"3"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *song=[resultArray objectAtIndex:i];
        NSLog(@"經典懷舊,民歌年代 sID:%@,name:%@,singer:%@",song.sID,song.name,song.singer);
    }
    NSLog(@"\n");
    //音域 Level2
    resultArray=[dbHelper searchByRange:@"" andRange:@""];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *range=[resultArray objectAtIndex:i];
        NSLog(@"音域Level2:%@",range);
    }
    //音域 Level3
    resultArray=[dbHelper searchByRange:@"C" andRange:@"13"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *song=[resultArray objectAtIndex:i];
        NSLog(@"音域 Level3 lang:%@,range:%@,sID:%@,name:%@,singer:%@",song.lang,song.range,song.sID,song.name,song.singer);
    }
    NSLog(@"\n");
    //舞曲 Level2
    resultArray=[dbHelper searchByDance:@""];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *lang=[resultArray objectAtIndex:i];
        NSLog(@"舞曲Level2:%@",lang);
    }
    NSLog(@"\n");
    
    //舞曲 Level3
    resultArray=[dbHelper searchByDance:@"C"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"舞曲Level3 lang:%@,dance:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.dance,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    NSLog(@"\n");
    //情境 Level2 @"":列出以下6個選項 1:友情不渝 2:愛情萬歲 3:失戀悲歌 4:勵志向上 5:感嘆人生 6:酒場文化
    resultArray=[dbHelper searchByScen:@""];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *lang=[resultArray objectAtIndex:i];
        NSLog(@"情境Level2:%@",lang);
    }
    NSLog(@"\n");
    
    //情境 Level3
    resultArray=[dbHelper searchByScen:@"6"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"情境Level3 lang:%@,scen:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.scen,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    NSLog(@"\n");
    //節奏 Level2 @"":列出以下27個選項
    resultArray=[dbHelper searchByTempo:@""];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *lang=[resultArray objectAtIndex:i];
        NSLog(@"節奏Level2:%@",lang);
    }
    NSLog(@"\n");
    
    //大陸
    resultArray=[dbHelper searchByClass:@"CN"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"大陸 lang:%@,class_0:%@,class_1:%@,class_2:%@,class_3:%@,class_4:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.class_0,sItem.class_1,sItem.class_2,sItem.class_3,sItem.class_4,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    //會場
    resultArray=[dbHelper searchByClass:@"W"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"會場 lang:%@,class_0:%@,class_1:%@,class_2:%@,class_3:%@,class_4:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.class_0,sItem.class_1,sItem.class_2,sItem.class_3,sItem.class_4,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    //其他 Level2
    resultArray=[dbHelper searchByClass:@"other"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *other=[resultArray objectAtIndex:i];
        NSLog(@"其他Level2:%@",other);
    }
    //其他 Level3
    resultArray=[dbHelper searchByClass:@"R"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"兒童 lang:%@,class_0:%@,class_1:%@,class_2:%@,class_3:%@,class_4:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.class_0,sItem.class_1,sItem.class_2,sItem.class_3,sItem.class_4,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    //音樂欣賞 Level2
    resultArray=[dbHelper searchByClass:@"music"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *music=[resultArray objectAtIndex:i];
        NSLog(@"音樂Level2:%@",music);
    }
    //音樂欣賞 Level3
    resultArray=[dbHelper searchByClass:@"M"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"綜合音樂 lang:%@,class_0:%@,class_1:%@,class_2:%@,class_3:%@,class_4:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.class_0,sItem.class_1,sItem.class_2,sItem.class_3,sItem.class_4,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    
    NSLog(@"\n");
    //歌曲關鍵字
    resultArray=[dbHelper searchByKeyword:@"song" andKeyword:@"海"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        SongItem *sItem=[resultArray objectAtIndex:i];
        NSLog(@"歌曲關鍵字 '海' lang:%@,class_0:%@,class_1:%@,class_2:%@,class_3:%@,class_4:%@,ID:%@,name:%@,singer:%@,word:%d,筆畫：%d,%d,%d",sItem.lang,sItem.class_0,sItem.class_1,sItem.class_2,sItem.class_3,sItem.class_4,sItem.sID,sItem.name,sItem.singer,sItem.word.intValue,sItem.w1.intValue,sItem.w2.intValue,sItem.w3.intValue);
    }
    NSLog(@"\n");
    //歌手關鍵字
    resultArray=[dbHelper searchByKeyword:@"singer" andKeyword:@"麗"];
    NSLog(@"found %ld results",resultArray.count);
    for (int i=0; i<[resultArray count]; i++) {
        NSString *singerName=[resultArray objectAtIndex:i];
        NSLog(@"歌手名關鍵字 '鄧':%@",singerName);
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
