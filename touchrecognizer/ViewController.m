//
//  ViewController.m
//  touchrecognizer
//
//  Created by shohei on 4/4/13.
//  Copyright (c) 2013 shohei. All rights reserved.
//

#import "ViewController.h"

int X_min = 2;
int X_max = 1019;
int MX_min = 100;
int MX_max = 7900;
int Y_min = -19;
int Y_max = 740;
int MY_min = 100;
int MY_max = 5900;

NSString *url = @"http://carpenter.ai.local/startMilling";
NSString *postString;
NSMutableURLRequest *request;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 1.anyObjectメソッドでいずれか1つのタッチを取得
    // 2.locationViewメソッドで対象となるビューのタッチした座標を取得
    CGPoint p = [[touches anyObject] locationInView:self.view];
    float x = p.x;    // X座標
    float y = p.y;    // Y座標
    float MX = [self calcMX:x];
    float MY = [self calcMY:y];
    
    _labelX.text = [NSString stringWithFormat:@"%.0f",x];
    _labelY.text = [NSString stringWithFormat:@"%.0f",y];
    _labelMX.text = [NSString stringWithFormat:@"%.0f",MX];
    _labelMY.text = [NSString stringWithFormat:@"%.0f",MY];
    [self sendData:MX MY:MY];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // 1.anyObjectメソッドでいずれか1つのタッチを取
    // 2.locationViewメソッドで対象となるビューのタッチした座標を取得
    CGPoint p = [[touches anyObject] locationInView:self.view];
    float x = p.x;    // X座標
    float y = p.y;    // Y座標

    _labelX.text = [NSString stringWithFormat:@"%.0f",x];
    _labelY.text = [NSString stringWithFormat:@"%.0f",y];
    _labelMX.text = [NSString stringWithFormat:@"%.0f",[self calcMX:x]];
    _labelMY.text = [NSString stringWithFormat:@"%.0f",[self calcMY:y]];
    
}

- (float) calcMX:(float)X {
    int MX = X /( (X_max - X_min) * 1.0) * (MX_max - MX_min);
    return MX;
}

- (float) calcMY:(float)Y {
    float reverse_Y = -1.0 * Y + (Y_max+Y_min);
    NSLog(@"%.0f",reverse_Y);
    float MY = (reverse_Y - Y_min) /( (Y_max - Y_min) * 1.0) * (MY_max - MY_min);//Make reverse_y postive
    return MY;
}

-(void) sendData:(float)MX MY:(float)MY{
    // POSTパラメーターを設定
    int MXi = (int)MX;
    int MYi = (int)MY;
    NSString *cuttingData = [NSString stringWithFormat:@"PA;PA;VS4;!VZ4;!PZ0,20;PU%d,%d;",MXi,MYi] ;
    NSString *escapedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                                                                                 kCFAllocatorDefault,(CFStringRef)cuttingData, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    NSString *baseparam = @"milData=";
    NSString *param = [baseparam stringByAppendingFormat:@"%@", escapedString];
    
    postString = [NSString stringWithFormat:@"%@", param];
    
    // リクエスト設定
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 送信
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [NSMutableData data];
    }
}


@end
