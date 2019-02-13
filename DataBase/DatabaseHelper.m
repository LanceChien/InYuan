#import "DatabaseHelper.h"
#import "GlobalData.h"


@interface DatabaseHelper()

@property (strong, nonatomic) NSString *remainingString;
@property (strong, nonatomic) FMDatabase *database;

@end

@implementation DatabaseHelper

//User我的K房
//新增User
-(void)addUserToKRoom:(NSString *)userName{
    GlobalData *sharedManager=[GlobalData sharedManager];
    _database=sharedManager.database;
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM KRoomTable WHERE userName=? AND type=?",userName,@"1"];
    if([rs next]){
        NSLog(@"使用者 %@ 已經加入K房，不可新增",userName);
    }else{
        BOOL success=[_database executeUpdate:@"INSERT INTO KRoomTable (userName, type) VALUES (?, ?)",userName,@"1"];
        if(success)
            NSLog(@"Database 新增使用者 %@",userName);
        else
            NSLog(@"Database 新增使用者 %@ 失敗",userName);
    }
}
//列出所有User
-(NSArray *)searchAllUser{
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs=[_database executeQuery:@"SELECT userName FROM KRoomTable WHERE type=?",@"1"];
    
    while ([rs next]){
        NSString *user=[NSString new];
        user=[rs stringForColumn:@"userName"];
        
        if(![result containsObject:user]){
            [result addObject:user];
            //NSLog(@"新增User：%@",user);
        }
    }
    
    return result;
}
//新增最愛歌曲到User的K房
-(void)addToKRoom:(KRoomItem *)kItem{
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM KRoomTable WHERE userName=? AND sID=?",kItem.userName,kItem.sID];
    if([rs next]){
        NSLog(@"%@K房內已經有歌號%@",kItem.userName,kItem.sID);
    }else{
        NSString *sql = @"insert into KRoomTable (userName,editName,sID,icon,key,tone,type,name,size,time,songType,rev_0,rev_1,rev_2,rev_3,rev_4) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        BOOL success=[_database executeUpdate:sql,kItem.userName,kItem.editName,kItem.sID,kItem.icon,kItem.key,kItem.tone,kItem.type,kItem.name,kItem.size,kItem.time,kItem.songType,kItem.rev_0,kItem.rev_1,kItem.rev_2,kItem.rev_3,kItem.rev_4];
        if(success)
            NSLog(@"Database %@新增我的K房,歌曲 %@",kItem.userName,kItem.name);
        else
            NSLog(@"Database %@新增%@到K房失敗",kItem.userName,kItem.name);
    }
}
//列出User的最愛歌曲,錄音,錄影
-(NSArray *)searchByKRoom:(NSString *)userName andType:(NSString *)type{
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM KRoomTable WHERE userName=? AND type=?",userName,type];
    while ([rs next]){
        KRoomItem *kItem=[KRoomItem new];
        kItem.userName=[rs stringForColumn:@"userName"];
        kItem.sID=[rs stringForColumn:@"sID"];
        kItem.name=[rs stringForColumn:@"name"];
        [result addObject:kItem];
    }
    
    return result;
}
/*
//列出User的錄音、錄影
-(NSArray *)searchByRecorded:(NSString *)userName{
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM RecordedTable WHERE userName=? AND type=?",userName,type];
    while ([rs next]){
        UserItem *uItem=[UserItem new];
        uItem=[self assignUserFromDBQuery:rs];
        [result addObject:uItem];
    }
    
    return result;
}*/


//static FMDatabase *_database = [GlobalData sharedManager].database;

-(void)deleteDB{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"InYuan.db"];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    _database = nil;
}
-(void)deleteTable{
    _database=[GlobalData sharedManager].database;
    [_database open];
    BOOL success=[_database executeUpdate:@"drop table if exists KRoomTable"];
    if(!success)
        NSLog(@"drop KRoomTable failure");
}
-(void)createDB{
    _database=[GlobalData sharedManager].database;
    BOOL success=[_database open];
    if(!success)
        NSLog(@"Database Open error");
    //create song table
    success=[_database executeUpdate:@"create table if not exists songTable(sID text not null,lyc text default null,name text default null,singer text default null,gender text default null,objectType text default null,tempo_0 text default null,tempo_1 text default null,tempo_2 text default null,tempo_3 text default null,tempo_4 text default null,duet text default null,lang text default null,class_0 text default null,class_1 text default null,class_2 text default null,class_3 text default null,class_4 text default null,songGender text default null,dance text default null,nost text default null,scen text default null,w1 integer default null,w2 integer default null,w3 integer default null,word integer default null,jw1 text default null,year text default null,range integer default null,wa1 integer default null,wa2 integer default null,wa3 integer default null,iystar text default null,top text default null,icon text default null,cr text default null,tone text default null,toneIcon text default null,rev_0 text default null,rev_1 text default null,rev_2 text default null,rev_3 text default null,rev_4 text default null)"];
    if(!success)
        NSLog(@"Database Song Table create error");
    //create KRoom table type:1 user 3 favorite 4 recorded audio 5 recorded video
    success=[_database executeUpdate:@"create table if not exists KRoomTable(userName text not null,editName text default null,sID text default null,icon text default null,key text default null,tone text default null,type text default null,name text default null,size text default null,time text default null,songType text default null,rev_0 text default null,rev_1 text default null,rev_2 text default null,rev_3 text default null,rev_4 text default null)"];
    if(!success)
        NSLog(@"Database KRoom Table create error");
    
    //create SongQueueList table
    success=[_database executeUpdate:@"create table if not exists SongQueueListTable(sID text not null,time text default null,ic text default null,off text default null,sic text default null,name text default null,stp text default null,to text default null,tp text default null,uid text default null,nsons text default null)"];
    if(!success)
        NSLog(@"Database KRoom Table create error");
    [self parseJSONToDBFromFile];
}

//SongBook VC middle ware
-(NSArray *)searchByMenu:(NSInteger)menu1ID andMenu2ID:(NSInteger)menu2ID andWord:(NSInteger)word andBegin:(NSInteger)begin andCount:(NSInteger)count{
    GlobalData *sharedManager=[GlobalData sharedManager];
    _database=sharedManager.database;
    
    switch (menu1ID) {
        case 0:
            switch (menu2ID) {
                case 0:
                    NSLog(@"查詢國語歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"C" andWord:word andBegin:begin andCount:count];
                case 1:
                    NSLog(@"查詢台語歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"T" andWord:word andBegin:begin andCount:count];
                case 2:
                    NSLog(@"查詢客語歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"K" andWord:word andBegin:begin andCount:count];
                case 3:
                    NSLog(@"查詢粵語歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"GD" andWord:word andBegin:begin andCount:count];
                case 4:
                    NSLog(@"查詢英文歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"E" andWord:word andBegin:begin andCount:count];
                case 5:
                    NSLog(@"查詢日文歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"J" andWord:word andBegin:begin andCount:count];
                case 6:
                    NSLog(@"查詢韓文歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"KR" andWord:word andBegin:begin andCount:count];
                case 7:
                    NSLog(@"查詢泰文歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"TH" andWord:word andBegin:begin andCount:count];
                case 8:
                    NSLog(@"查詢越文歌曲 %ld 字部, begin %ld, count %ld",word,begin,count);
                    return [self searchByLang:@"VN" andWord:word andBegin:begin andCount:count];
                default:
                    break;
            }
        case 1:
            NSLog(@"查詢我的K房");
            break;
        case 2:
            switch (menu2ID) {
                case 0:
                    NSLog(@"查詢音圓歌手");
                    return [self searchIYStar];
                case 1:
                    NSLog(@"查詢音圓歌曲");
                    return [self searchIYSong];
                default:
                    break;
            }
        case 3:
            //NSLog(@"查詢歌手");
            switch (menu2ID) {
                case 0:
                    NSLog(@"查詢華語男歌手");
                    return [self searchBySinger:@"C" andGender:1 andBegin:begin andCount:count];
                case 1:
                    NSLog(@"查詢華語女歌手");
                    return [self searchByLang:@"C" andWord:2 andBegin:begin andCount:count];
                case 2:
                    NSLog(@"查詢華語團體歌手");
                    return [self searchByLang:@"C" andWord:4 andBegin:begin andCount:count];
                case 3:
                    NSLog(@"查詢外語男歌手");
                    return [self searchByLang:@"F" andWord:1 andBegin:begin andCount:count];
                case 4:
                    NSLog(@"查詢外語女歌手");
                    return [self searchByLang:@"F" andWord:2 andBegin:begin andCount:count];
                case 5:
                    NSLog(@"查詢外語團體歌手");
                    return [self searchByLang:@"F" andWord:4 andBegin:begin andCount:count];
                default:
                    break;
            }
        case 4:
            NSLog(@"查詢最新");
        case 5:
            NSLog(@"查詢常唱");
        case 6:
            NSLog(@"查詢對唱");
        case 7:
            NSLog(@"查詢經典懷舊");
        case 8:
            NSLog(@"查詢音域選歌");
        case 9:
            NSLog(@"查詢熱歌勁舞");
        case 10:
            NSLog(@"查詢情境");
        case 11:
            NSLog(@"查詢節奏");
        case 12:
            NSLog(@"查詢大陸歌曲");
        case 13:
            NSLog(@"查詢會場歌曲");
        case 14:
            NSLog(@"查詢其他");
        case 15:
            NSLog(@"查詢音樂欣賞");
            //[self searchByLang:@"C" andWord:@"1" andBegin:@"0" andCount:@"30"];
           break;
        case 16:
            NSLog(@"查詢影音收藏");
            break;
        default:
        break;
    }
    
    
    NSMutableArray *result = [NSMutableArray new];
    
    return result;
    
}
//語言選歌 SPEC p14 API p59 @"":列出九種語言 C:國語 T:台語 K:客語 GD:粵語 E:英文 J:日文 KR:韓文 TH:泰文 VN:越文, word是字部，1~8,9:9以上,其他:不分字部
//begin:搜尋結果從begin開始取，count是取出的筆數
-(NSArray *)searchByLang:(NSString *)lang andWord:(NSInteger)word andBegin:(NSInteger)begin andCount:(NSInteger)count{
    _database=[GlobalData sharedManager].database;
    if(![[NSArray arrayWithObjects:@"C",@"T",@"K",@"GD",@"E",@"J",@"KR",@"TH",@"VN",nil] containsObject:lang])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs=[FMResultSet new];
    NSString *wordStr = [NSString stringWithFormat: @"%ld", (long)word];
    NSString *beginStr = [NSString stringWithFormat: @"%ld", (long)begin];
    NSString *countStr = [NSString stringWithFormat: @"%ld", (long)count];

    
    
    if(word>0 && word<9)
        rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND word=? ORDER by w1 ASC,w2 ASC,w3 ASC LIMIT ?,?",lang,wordStr,beginStr,countStr];
    else if(word==9)//9字以上
        rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND word>=9 ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC LIMIT ?,?",lang,beginStr,countStr];
    else//不分字部
        rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC LIMIT ?,?",lang,beginStr,countStr];
    
    while ([rs next]){
        SongItem *sItem=[SongItem new];
        sItem=[self assignSongFromDBQuery:rs];
        [result addObject:sItem];
    }
    
    return result;
}
//根據 SongID 搜尋歌曲
-(SongItem *)searchByID:(NSString *)songID{
    SongItem *sItem=[SongItem new];
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE sID=?",songID];
    
    if([rs next]){
        sItem=[self assignSongFromDBQuery:rs];
    }else
        sItem=nil;
    
    return sItem;
}

//列出音圓star
-(NSArray *)searchIYStar{
    NSMutableArray *result = [NSMutableArray new];
    
    FMResultSet *rs=[_database executeQuery:@"SELECT singer FROM songTable WHERE duet=? AND iystar=? ORDER by wa1 ASC,wa2 ASC,wa3 ASC",@"0",@"1"];
    
    while ([rs next]){
        SongItem *sItem=[SongItem new];
        sItem=[self assignSongFromDBQuery:rs];
        
        [result addObject:sItem];
    }
    /*
    while ([rs next]){
        NSString *star=[NSString new];
        star=[rs stringForColumn:@"singer"];
        
        if(![result containsObject:star]){
            [result addObject:star];
            //NSLog(@"新增音圓之星：%@",star);
        }
    }*/
    
    return result;
}
//列出音圓歌曲
-(NSArray *)searchIYSong{
    NSMutableArray *result = [NSMutableArray new];
    
    FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE iystar=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",@"1"];
    
    while ([rs next]){
        SongItem *sItem=[SongItem new];
        sItem=[self assignSongFromDBQuery:rs];
        
        [result addObject:sItem];
    }
    
    return result;
}
//列出歌手
-(NSArray *)searchBySinger:(NSString *)lang andGender:(NSInteger)gender andBegin:(NSInteger)begin andCount:(NSInteger)count{
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs;
    NSString *genderStr = [NSString stringWithFormat: @"%ld", (long)gender];
    NSString *beginStr = [NSString stringWithFormat: @"%ld", (long)begin];
    NSString *countStr = [NSString stringWithFormat: @"%ld", (long)count];
    
    if([lang isEqualToString:@"C"])
        rs=[_database executeQuery:@"SELECT singer FROM songTable WHERE lang=? AND gender=? LIMIT ?,?",@"C",genderStr,beginStr,countStr];
    else if([lang isEqualToString:@"F"])
        rs=[_database executeQuery:@"SELECT singer FROM songTable WHERE (lang=? OR lang=? OR lang=? OR lang=? OR lang=?) AND gender=? LIMIT ?,?",@"E",@"J",@"KR",@"TH",@"VN",genderStr,beginStr,countStr];
    
    while ([rs next]){
        NSString *singer=[NSString new];
        singer=[rs stringForColumn:@"singer"];
        if(![result containsObject:singer]){
            [result addObject:singer];
            //NSLog(@"新增%@語歌手：%@",lang,singer);
        }
    }
    
    return result;
}
//對唱 SPEC p.14 API duet:p.57 lang:p58 @"":列出以下五個選項 C:國語 T:台語 GD:粵語 E:英文 J:日文
-(NSArray *)searchByDuet:(NSString *)lang{
    if(![[NSArray arrayWithObjects:@"",@"C",@"T",@"GD",@"E",@"J",nil] containsObject:lang])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND duet=2 ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    return result;
}
//經典懷舊 SPEC p.14 API p.59 0:列出以下六個選項 1:國語經典 2:台語經典 3:民歌年代 4:台灣歌謠 5:西洋經典 6:東洋經典
-(NSArray *)searchByNost:(NSString *)nost{
    if(![[NSArray arrayWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",nil] containsObject:nost])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE nost=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",nost];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    return result;
}
//音域 SPEC p.14 API lang:p58 @"":列出以下3個選項 C:國語 T:台語 GD:粵語 range:p.63 
-(NSArray *)searchByRange:(NSString *)lang andRange:(NSString *)range{
    if(![[NSArray arrayWithObjects:@"",@"C",@"T",@"GD",nil] containsObject:lang])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        int rangeCount=[range intValue];
        FMResultSet *rs;
        
        if(rangeCount<8)
            rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND range<8 ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang];
        else if(rangeCount>=9 && rangeCount<=10)
            rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND (range=9 OR range=10) ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang];
        else if(rangeCount>=13)
            rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND range>13 ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang];
        else if(rangeCount==8 || rangeCount==11 || rangeCount==12)
            rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND range=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang,range];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    return result;
}
//舞曲 SPEC p.14 API dance:p.57 lang:p58 @"":列出以下五個選項 C:國語 T:台語 GD:粵語 E:英文 J:日文
-(NSArray *)searchByDance:(NSString *)lang{
    if(![[NSArray arrayWithObjects:@"",@"C",@"T",@"GD",@"E",@"J",nil] containsObject:lang])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE lang=? AND dance=1 ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",lang];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    
    return result;
}
//情境 SPEC p.14 API scen:p60 @"":列出以下6個選項 1:友情不渝 2:愛情萬歲 3:失戀悲歌 4:勵志向上 5:感嘆人生 6:酒場文化
-(NSArray *)searchByScen:(NSString *)scen{
    if(![[NSArray arrayWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",nil] containsObject:scen])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE scen=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",scen];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    
    return result;
}
//節奏 SPEC p.14 API scen:p60 @"":列出以下27個選項
-(NSArray *)searchByTempo:(NSString *)tempo{
    if(![[NSArray arrayWithObjects:@"",@"10",@"11",@"12",@"13",@"7",@"1",@"2",@"14",@"15",@"3",@"4",@"5",@"6",@"C",@"8",@"16",@"9",@"A",@"B",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",nil] containsObject:tempo])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE tempo_0=? OR tempo_1=? OR tempo_2=? OR tempo_3=? OR tempo_4=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",tempo,tempo,tempo,tempo,tempo];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    
    return result;
}
//大陸歌曲等 SPEC p.14 API class:p61 other:其他 music:音樂欣賞 CN:大陸 W:會場
-(NSArray *)searchByClass:(NSString *)classCode{
    if(![[NSArray arrayWithObjects:@"other",@"music",@"CN",@"R",@"S",@"CZ",@"EZ",@"FV",@"W",@"F",@"M",@"H",@"CL",nil] containsObject:classCode])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
        FMResultSet *rs=[_database executeQuery:@"SELECT * FROM songTable WHERE class_0=? OR class_1=? OR class_2=? OR class_3=? OR class_4=? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC",classCode,classCode,classCode,classCode,classCode];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    
    return result;
}
//關鍵字搜尋歌曲或歌手
-(NSArray *)searchByKeyword:(NSString *)type andKeyword:(NSString *)keyword{
    if(![[NSArray arrayWithObjects:@"song",@"singer",nil] containsObject:type])
        return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    FMResultSet *rs;
    NSString *search=[[@"%" stringByAppendingString:keyword] stringByAppendingString:@"%"];
    if([type isEqualToString:@"song"]){
        rs=[_database executeQuery:@"SELECT * FROM songTable WHERE name LIKE ? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC,sID ASC",search];
        
        while ([rs next]){
            SongItem *sItem=[SongItem new];
            sItem=[self assignSongFromDBQuery:rs];
            [result addObject:sItem];
        }
    }else{
        rs=[_database executeQuery:@"SELECT * FROM songTable WHERE singer LIKE ? ORDER by word ASC,w1 ASC,w2 ASC,w3 ASC,sID ASC",search];
    
        while ([rs next]){
            NSString *singerName=[NSString new];
            singerName=[rs stringForColumn:@"singer"];
            if(![result containsObject:singerName]){
                [result addObject:singerName];
                //NSLog(@"新增%@語歌手：%@",lang,singer);
            }
        }
    }
    
    return result;
}
/* Inner Utility */

-(void)closeDatabase{
    [_database close];
    _database=nil;
}

//讀取JSON曲庫
-(void)parseJSONToDBFromFile{
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"originalData" ofType:@"dms"]];
    
    [self parseJSONToDBFromData:data];
}
-(void)parseJSONToDBFromData:(NSData *)data{
    //NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"originalData" ofType:@"dms"]];
    NSDictionary *jsonSongData = [NSDictionary new];
    jsonSongData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *jsonObj=[NSArray arrayWithArray:[jsonSongData objectForKey:@"song_list"]];
    for (int i=0;i<jsonObj.count;i++){
        SongItem *sItem=[SongItem new];
        sItem.sID=[[jsonObj objectAtIndex:i] valueForKey:@"id"];
        sItem.lyc=[[jsonObj objectAtIndex:i] valueForKey:@"lyc"];
        _remainingString=[[jsonObj objectAtIndex:i] valueForKey:@"name"];
        sItem.name=[self getSubString];
        sItem.singer=[self getSubString];
        sItem.gender=_remainingString;
        sItem.objectType=[[jsonObj objectAtIndex:i] valueForKey:@"objectType"];
        _remainingString=[[jsonObj objectAtIndex:i] valueForKey:@"parm"];
        sItem.tempo_0=[self getSubString];
        sItem.tempo_1=[self getSubString];
        sItem.tempo_2=[self getSubString];
        sItem.tempo_3=[self getSubString];
        sItem.tempo_4=[self getSubString];
        sItem.duet=[self getSubString];
        sItem.lang=[self getSubString];
        sItem.class_0=[self getSubString];
        sItem.class_1=[self getSubString];
        sItem.class_2=[self getSubString];
        sItem.class_3=[self getSubString];
        sItem.class_4=[self getSubString];
        sItem.songGender=[self getSubString];
        sItem.dance=[self getSubString];
        sItem.nost=[self getSubString];
        sItem.scen=[self getSubString];
        sItem.w1=[self getSubString];
        sItem.w2=[self getSubString];
        sItem.w3=[self getSubString];
        sItem.word=[self getSubString];
        sItem.jw1=[self getSubString];
        sItem.year=[self getSubString];
        sItem.range=[self getSubString];
        sItem.wa1=[self getSubString];
        sItem.wa2=[self getSubString];
        sItem.wa3=[self getSubString];
        sItem.IYStar=[self getSubString];
        sItem.top=[self getSubString];
        sItem.icon=[self getSubString];
        sItem.cr=[self getSubString];
        sItem.tone=[self getSubString];
        sItem.toneIcon=_remainingString;
        sItem.rev_0=@"";
        sItem.rev_1=@"";
        sItem.rev_2=@"";
        sItem.rev_3=@"";
        sItem.rev_4=@"";
        
        //將Song新增入資料庫
        NSInteger status=[self addSongItem:sItem andUser:@""];
        if(status==-1){
            NSLog(@"此資料庫已新增");
            break;
        }
    }
}

//將歌曲新增到資料庫
-(NSInteger)addSongItem:(SongItem *)songItem andUser:(NSString *)user{
    //if([user isEqualToString:@""]){//曲庫

        FMResultSet *rs = [_database executeQuery:@"SELECT * FROM songTable WHERE sID= ? LIMIT 1",songItem.sID];
        if([rs next]){
            NSLog(@"Database sID %@ exist, do not add",songItem.sID);
            return -1;
        }else{
            NSString *sql = @"insert into songTable (sID,lyc,name,singer,gender,objectType,tempo_0,tempo_1,tempo_2,tempo_3,tempo_4,duet,lang,class_0,class_1,class_2,class_3,class_4,songGender,dance,nost,scen,w1,w2,w3,word,jw1,year,range,wa1,wa2,wa3,iystar,top,icon,cr,tone,toneIcon,rev_0,rev_1,rev_2,rev_3,rev_4) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
            BOOL success=[_database executeUpdate:sql,songItem.sID,songItem.lyc,songItem.name,songItem.singer,songItem.gender,songItem.objectType,songItem.tempo_0,songItem.tempo_1,songItem.tempo_2,songItem.tempo_3,songItem.tempo_4,songItem.duet,songItem.lang,songItem.class_0,songItem.class_1,songItem.class_2,songItem.class_3,songItem.class_4,songItem.songGender,songItem.dance,songItem.nost,songItem.scen,songItem.w1,songItem.w2,songItem.w3,songItem.word,songItem.jw1,songItem.year,songItem.range,songItem.wa1,songItem.wa2,songItem.wa3,songItem.IYStar,songItem.top,songItem.icon,songItem.cr,songItem.tone,songItem.toneIcon,songItem.rev_0,songItem.rev_1,songItem.rev_2,songItem.rev_3,songItem.rev_4];
            if(success)
                NSLog(@"Database 新增歌曲 %@",songItem.name);
            else
                NSLog(@"Database 新增歌曲失敗");
        }
    //}else{//我的K房
    /*
    NSString *sql = @"insert into KRoomTable (userName,sID,lyc,name,singer,gender,objectType,tempo_0,tempo_1,tempo_2,tempo_3,tempo_4,duet,lang,class_0,class_1,class_2,class_3,class_4,songGender,dance,nost,scen,w1,w2,w3,word,jw1,year,range,wa1,wa2,wa3,iystar,top,icon,cr,tone,toneIcon,rev_0,rev_1,rev_2,rev_3,rev_4) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        BOOL success=[_database executeUpdate:sql,user,songItem.sID,songItem.lyc,songItem.name,songItem.singer,songItem.gender,songItem.objectType,songItem.tempo_0,songItem.tempo_1,songItem.tempo_2,songItem.tempo_3,songItem.tempo_4,songItem.duet,songItem.lang,songItem.class_0,songItem.class_1,songItem.class_2,songItem.class_3,songItem.class_4,songItem.songGender,songItem.dance,songItem.nost,songItem.scen,songItem.w1,songItem.w2,songItem.w3,songItem.word,songItem.jw1,songItem.year,songItem.range,songItem.wa1,songItem.wa2,songItem.wa3,songItem.IYStar,songItem.top,songItem.icon,songItem.cr,songItem.tone,songItem.toneIcon,songItem.rev_0,songItem.rev_1,songItem.rev_2,songItem.rev_3,songItem.rev_4];
        if(success)
            NSLog(@"Database %@新增我的K房,歌曲 %@",user,songItem.name);
        else
            NSLog(@"Database %@新增%@到K房失敗",user,songItem.name);
    }*/
    return 0;
}
//把","之前的string取出來
-(NSString *)getSubString{
    NSUInteger location = [_remainingString rangeOfString:@","].location;
    if(location!=NSNotFound){
        NSString *subString = [_remainingString substringToIndex:location];//读取符号前面的字符
        NSRange range = NSMakeRange(location+1, (_remainingString.length-location- 1));//设置符号后面的字符的范围
        _remainingString = [_remainingString substringWithRange:range];//在整的字符串里面，根据范围打印出字符
        return subString;
    }
    else{
        return @"";
    }
}

-(SongItem *)assignSongFromDBQuery:(FMResultSet *)rs{
    SongItem *sItem=[SongItem new];
    sItem.sID=[rs stringForColumn:@"sID"];
    sItem.lyc=[rs stringForColumn:@"lyc"];
    sItem.name=[rs stringForColumn:@"name"];
    sItem.singer=[rs stringForColumn:@"singer"];
    sItem.gender=[rs stringForColumn:@"gender"];
    sItem.objectType=[rs stringForColumn:@"objectType"];
    sItem.tempo_0=[rs stringForColumn:@"tempo_0"];
    sItem.tempo_1=[rs stringForColumn:@"tempo_1"];
    sItem.tempo_2=[rs stringForColumn:@"tempo_2"];
    sItem.tempo_3=[rs stringForColumn:@"tempo_3"];
    sItem.tempo_4=[rs stringForColumn:@"tempo_4"];
    sItem.duet=[rs stringForColumn:@"duet"];
    sItem.lang=[rs stringForColumn:@"lang"];
    sItem.class_0=[rs stringForColumn:@"class_0"];
    sItem.class_1=[rs stringForColumn:@"class_1"];
    sItem.class_2=[rs stringForColumn:@"class_2"];
    sItem.class_3=[rs stringForColumn:@"class_3"];
    sItem.class_4=[rs stringForColumn:@"class_4"];
    sItem.songGender=[rs stringForColumn:@"songGender"];
    sItem.dance=[rs stringForColumn:@"dance"];
    sItem.nost=[rs stringForColumn:@"nost"];
    sItem.scen=[rs stringForColumn:@"scen"];
    sItem.w1=[rs stringForColumn:@"w1"];
    sItem.w2=[rs stringForColumn:@"w2"];
    sItem.w3=[rs stringForColumn:@"w3"];
    sItem.word=[rs stringForColumn:@"word"];
    sItem.jw1=[rs stringForColumn:@"jw1"];
    sItem.year=[rs stringForColumn:@"year"];
    sItem.range=[rs stringForColumn:@"range"];
    sItem.wa1=[rs stringForColumn:@"wa1"];
    sItem.wa2=[rs stringForColumn:@"wa2"];
    sItem.wa3=[rs stringForColumn:@"wa3"];
    sItem.IYStar=[rs stringForColumn:@"IYStar"];
    sItem.top=[rs stringForColumn:@"top"];
    sItem.icon=[rs stringForColumn:@"icon"];
    sItem.cr=[rs stringForColumn:@"cr"];
    sItem.tone=[rs stringForColumn:@"tone"];
    sItem.toneIcon=[rs stringForColumn:@"toneIcon"];
    sItem.rev_0=@"";
    sItem.rev_1=@"";
    sItem.rev_2=@"";
    sItem.rev_3=@"";
    sItem.rev_4=@"";
    
    return sItem;
}
-(UserItem *)assignUserFromDBQuery:(FMResultSet *)rs{
    UserItem *uItem=[UserItem new];
    uItem.userName=[rs stringForColumn:@"userName"];
    uItem.song=[self assignSongFromDBQuery:rs];
    
    return uItem;
}

@end
