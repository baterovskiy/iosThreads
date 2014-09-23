//
//  ViewController.m
//  iosThreads
//
//  Created by unit891 on 9/23/14.
//  Copyright (c) 2014 boom inc. All rights reserved.
//

#import "ViewController.h"

#include <pthread.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtOutput;
- (IBAction)btnPosix:(UIButton *)sender;
- (IBAction)btnGCD:(UIButton *)sender;
- (IBAction)btnNSThread:(UIButton *)sender;

@property (strong, nonatomic) NSThread *thread;
-(void)WorkerThread:(NSString*) paramContext;
@end



static void* pt_callback(void* context);




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

- (IBAction)btnPosix:(UIButton *)sender {
    pthread_attr_t  attr;
    pthread_t       posixThreadID;
    int             returnVal;
    
    returnVal = pthread_attr_init(&attr);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    
    int threadError = pthread_create(&posixThreadID, &attr, &pt_callback, (__bridge void *)(self));
    
    returnVal = pthread_attr_destroy(&attr);
    if (threadError != 0) {}
    
}

- (IBAction)btnGCD:(UIButton *)sender {
    NSString* memo = @"GCD ";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ [self WorkerThread:memo];});
}

- (IBAction)btnNSThread:(UIButton *)sender {
    NSString* memo = @"NSThread ";
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(WorkerThread:) object:memo];
    [self.thread start];
}



//-----------------

-(void)WorkerThread:(NSString*) paramContext
{
    for (int i=0; i<=10; i++) {
        NSLog(@"%@ :: %@", [@(i) stringValue], paramContext);
        [NSThread sleepForTimeInterval:.8];
        
    }
}
@end


void* pt_callback(void* context)
{
    ViewController *object = (__bridge ViewController *)context;
    [object WorkerThread:@"posix"];
    
    return 0;
}

