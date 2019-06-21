// **********************************************************************
//
// Copyright (c) 2003-2018 ZeroC, Inc. All rights reserved.
//
// **********************************************************************

#import "LoginController.h"
#import "ChatController.h"

#import <objc/Ice.h>
#import <objc/Glacier2.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "VoiceManager/VoiceConvertHandle.h"

@interface LoginController()<VoiceConvertHandleDelegate>

@property (nonatomic) UITextField* currentField;
@property (nonatomic) NSString* oldFieldValue;
@property (nonatomic) WaitAlert* waitAlert;
@property (nonatomic) ChatController* chatController;
@property (nonatomic) id<ICECommunicator> communicator;

@property(nonatomic,strong) NSURL *url; //流媒体播放地址
@property(nonatomic,retain) id<IJKMediaPlayback> ijkPlayer; //播放器
@property(nonatomic,strong) UIView *playView;

@end

@implementation LoginController

@synthesize currentField;
@synthesize oldFieldValue;
@synthesize waitAlert;
@synthesize chatController;
@synthesize communicator;

static NSString* usernameKey = @"usernameKey";
static NSString* passwordKey = @"passwordKey";
static NSString* sslKey = @"sslKey";

+(void)initialize
{
    NSDictionary* appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"", usernameKey,
                                 @"", passwordKey,
                                 @"YES", sslKey,
                                 nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}
- (IBAction)talkAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [VoiceConvertHandle shareInstance].startRecord = sender.selected;
    [VoiceConvertHandle shareInstance].delegate = self;
}
static int i = 0;
- (void)covertedData:(NSData *)data{
    [[VoiceConvertHandle shareInstance] playWithData:data];
}
- (void)loadijkPlayer{
    return;
    self.url = [NSURL URLWithString:@"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov"];
    
    //调整参数
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    //ijk播放器
    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    //播放区域
    self.playView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, 300)];
    self.playView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.playView];
    
    UIView *playingView = [self.ijkPlayer view];
    playingView.frame = self.playView.bounds;
    //    playingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.playView insertSubview:playingView atIndex:1];
    
    //
    [self.ijkPlayer setScalingMode:IJKMPMovieScalingModeFill];
    [self installMovieNotificationObservers];
    if(![self.ijkPlayer isPlaying]){
        [self.ijkPlayer prepareToPlay];
    }
}
//network load state changes
- (void)loadStateDidChange:(NSNotification *)notification{
    IJKMPMovieLoadState loadState = self.ijkPlayer.loadState;
    NSLog(@"LoadStateDidChange : %d",(int)loadState);
}

//when movie playback ends or a user exits playback.
- (void)moviePlayBackFinish:(NSNotification *)notification{
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    NSLog(@"playBackFinish : %d",reason);
}

//
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification{
    NSLog(@"mediaIsPrepareToPlayDidChange");
}

// when the playback state changes, either programatically or by the user
- (void)moviePlayBackStateDidChange:(NSNotification *)notification{
    switch (_ijkPlayer.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"playBackState %d: stoped", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"playBackState %d: playing", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"playBackState %d: paused", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"playBackState %d: interrupted", (int)self.ijkPlayer.playbackState);
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            break;
        default:
            break;
    }
}


- (void)installMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ijkPlayer];
}

- (void)removeMovieNotificationObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.ijkPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:self.ijkPlayer];
}

- (void)viewDidLoad
{
    [self loadijkPlayer];
    // Register IceSSL/IceWS plugins and load them on communicator initialization.
    ICEregisterIceSSL(YES);
    ICEregisterIceWS(YES);

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    // Set the default values, and show the clear button in the text field.
    usernameField.text =  [defaults stringForKey:usernameKey];
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.text = [defaults stringForKey:passwordKey];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;

    chatController = [[ChatController alloc] initWithNibName:@"ChatView" bundle:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

-(void) connecting:(BOOL)v
{
    // Show the wait alert.
    statusLabel.text = @"Connecting...";

    statusLabel.hidden = !v;
    if(v)
    {
        [statusActivity startAnimating];
    }
    else
    {
        [statusActivity stopAnimating];
    }
    loginButton.enabled = !v;
    usernameField.enabled = !v;
    passwordField.enabled = !v;
}

- (void)applicationDidEnterBackground
{
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.communicator destroy];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    loginButton.enabled = usernameField.text.length > 0;
    [loginButton setAlpha:loginButton.enabled ? 1.0 : 0.5];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField*)field
{
    self.currentField = field;
    self.oldFieldValue = field.text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    NSAssert(theTextField == currentField, @"theTextField == currentTextField");

    // When the user presses return, take focus away from the text
    // field so that the keyboard is dismissed.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(theTextField == usernameField)
    {
        [defaults setObject:theTextField.text forKey:usernameKey];
    }
    else if(theTextField == passwordField)
    {
        [defaults setObject:theTextField.text forKey:passwordKey];
    }
    loginButton.enabled = usernameField.text.length > 0;
    [loginButton setAlpha:loginButton.enabled ? 1.0 : 0.5];

    [theTextField resignFirstResponder];
    self.currentField = nil;

    return YES;
}

#pragma mark -

// A touch outside the keyboard dismisses the keyboard, and
// sets back the old field value.
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.ijkPlayer play];
    [currentField resignFirstResponder];
    currentField.text = oldFieldValue;
    self.currentField = nil;
    [super touchesBegan:touches withEvent:event];
}

#pragma mark UI Actions

-(IBAction)sslChanged:(id)s
{
    UISwitch* sender = (UISwitch*)s;
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:sslKey];
}

#pragma mark Login

-(void)exception:(NSString*)s
{
    [self connecting:FALSE];

    // We always create a new communicator each time
    // we try to login.
    [communicator destroy];
    self.communicator = nil;

    loginButton.enabled = usernameField.text.length > 0;
    [loginButton setAlpha:loginButton.enabled ? 1.0 : 0.5];

    // open an alert with just an OK button
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:s
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)login:(id)sender
{
    ICEInitializationData* initData = [ICEInitializationData initializationData];

    initData.properties = [ICEUtil createProperties];
    [initData.properties load:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"config.client"]];
    [initData.properties setProperty:@"Ice.ACM.Client.Timeout" value:@"0"];
    [initData.properties setProperty:@"Ice.RetryIntervals" value:@"-1"];

    initData.dispatcher = ^(id<ICEDispatcherCall> call, id<ICEConnection> con)
    {
        dispatch_sync(dispatch_get_main_queue(), ^ { [call run]; });
    };

    NSAssert(communicator == nil, @"communicator == nil");
    self.communicator = [ICEUtil createCommunicator:initData];

    [self connecting:TRUE];

    NSString* username = usernameField.text;
    NSString* password = passwordField.text;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        @try
        {
            id<GLACIER2RouterPrx> router = [GLACIER2RouterPrx checkedCast:[self.communicator getDefaultRouter]];
            id<GLACIER2SessionPrx> glacier2session = [router createSession:username password:password];
            id<ChatChatSessionPrx> sess = [ChatChatSessionPrx uncheckedCast:glacier2session];

            ICEInt acmTimeout = [router getACMTimeout];
            if(acmTimeout <= 0)
            {
                acmTimeout = (ICEInt)[router getSessionTimeout];
            }

            [self.chatController setup:self.communicator
                                session:sess
                             acmTimeout:acmTimeout
                                 router:router
                               category:[router getCategoryForClient]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self connecting:FALSE];

                // The communicator is now owned by the ChatController.
                self.communicator = nil;

                [self.chatController activate:@"Chat"];
                [self.navigationController pushViewController:self.chatController animated:YES];
            });
        }
        @catch(GLACIER2CannotCreateSessionException* ex)
        {
            NSString* s = [NSString stringWithFormat:@"Session creation failed: %@", ex.reason_];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:s];
            });
        }
        @catch(GLACIER2PermissionDeniedException* ex)
        {
            NSString* s = [NSString stringWithFormat:@"Login failed: %@", ex.reason_];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:s];
            });
        }
        @catch(ICEEndpointParseException* ex)
        {
            NSString* s = [NSString stringWithFormat:@"Invalid router: %@", ex.reason];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:s];
            });
        }
        @catch(ICEException* ex)
        {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:[ex description]];
            });
        }
    });
}

@end
