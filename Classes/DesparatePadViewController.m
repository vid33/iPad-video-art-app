//
//  DesparatePadViewController.m
//  DesparatePad
//
//  Created by Vid Stojevic on 22/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DesparatePadViewController.h"

@implementation DesparatePadViewController

//@synthesize start;

@synthesize movieplayer;

@synthesize currentMovie;
@synthesize currentMovieExtension;

@synthesize playbackPositionSlider;
@synthesize playbackRateSlider;
@synthesize velocitySensitivitySlider;
@synthesize updateIntervalSlider;
@synthesize resetThresholdSlider;
@synthesize resetIntervalSlider;

@synthesize XYZSegmented;
@synthesize randomSegmented;

@synthesize labelX;
@synthesize labelY;
@synthesize labelZ;
@synthesize labelvelX;
@synthesize labelvelY;
@synthesize labelvelZ;
@synthesize playbackPositionLabel;
@synthesize playbackRateLabel;
@synthesize velocitySensitivityLabel;
@synthesize updateIntervalLabel;
@synthesize resetThresholdLabel;
@synthesize resetIntervalLabel;

@synthesize swingSwitch;
@synthesize readoutSwitch;
@synthesize twitchSwitch;

@synthesize accelerometer;

@synthesize externalWindow;
@synthesize consoleTextView;
@synthesize vgaSwitch;

- (void) resetSliders {
	playbackPositionSlider.value = 0;
	playbackPositionSlider.continuous = NO;
	playbackPositionLabel.text = [NSString stringWithFormat:@"%.2f", playbackPositionSlider.value];
	
	playbackRateSlider.minimumValue = -4.0;
	playbackRateSlider.maximumValue = 4.0;
	playbackRateSlider.value = 1.0;
	playbackRateSlider.continuous = NO;
	playbackRateLabel.text = [NSString stringWithFormat:@"%.2f", playbackRateSlider.value];
	
	velocitySensitivitySlider.continuous = NO;
	velocitySensitivitySlider.minimumValue= -15;
	velocitySensitivitySlider.maximumValue = 15;
	velocitySensitivitySlider.value = 1;
	velocitySensitivityLabel.text = [NSString stringWithFormat:@"%.1f", velocitySensitivitySlider.value];
	
	updateIntervalSlider.continuous = NO;
	updateIntervalSlider.minimumValue= 0.05;
	updateIntervalSlider.maximumValue = 0.3;
	updateIntervalSlider.value = 0.1;
	updateIntervalLabel.text = [NSString stringWithFormat:@"%.2f", updateIntervalSlider.value];
	
	resetThresholdSlider.continuous = NO;
	resetThresholdSlider.minimumValue = 0.05;
	resetThresholdSlider.maximumValue = 0.3;
	resetThresholdSlider.value = 0.1;
	resetThresholdLabel.text  = [NSString stringWithFormat:@"%.2f", resetThresholdSlider.value];
	
	resetIntervalSlider.continuous = NO;
	resetIntervalSlider.minimumValue = 0;
	resetIntervalSlider.maximumValue = 300;
	resetIntervalSlider.value = 10;
	resetIntervalLabel.text = [NSString stringWithFormat:@"%.0f", resetIntervalSlider.value];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	srand ( time(NULL) );
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector
	 (playingDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

	[self resetSliders];
	labelX.text = [NSString stringWithFormat:@"N/A"];
	labelY.text = [NSString stringWithFormat:@"N/A"];
	labelZ.text = [NSString stringWithFormat:@"N/A"];
	labelvelX.text = [NSString stringWithFormat:@"N/A"];
	labelvelY.text = [NSString stringWithFormat:@"N/A"];
	labelvelZ.text = [NSString stringWithFormat:@"N/A"];

	velX = 999; velY=999; velZ=999;
	prevX = 999; prevY=999; prevZ=999;
	smoothX=0; smoothY=0; smoothZ=0;
	smoothVelX = 0; smoothVelY=0; smoothVelZ=0;
	XYZSegmented.selectedSegmentIndex = 1;
	
	twitchValue = 0.01;
	
	currentMovie = [NSString stringWithFormat:@"Glasgow_4000"];
	currentMovieExtension = [NSString stringWithFormat:@"mov"];
	[self movieplayerAlloc: currentMovie movieExtension: currentMovieExtension];
	
	[self.view addSubview:movieplayer.view];
		
	self.accelerometer = [UIAccelerometer sharedAccelerometer];
	self.accelerometer.updateInterval = updateIntervalSlider.value;
	self.accelerometer.delegate = self;
	
    [super viewDidLoad];
	//NSLog(@"Number of screens: %d", [[UIScreen screens]count]);
}

- (void) movieplayerAlloc: (NSString *) movieName movieExtension: (NSString *) extension{
	resetTime = 0; haveResetTime = 0;
	
	movieplayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] 
												pathForResource:movieName ofType:extension]]];
	
	movieplayer.controlStyle = MPMovieControlStyleNone;
	movieplayer.scalingMode = MPMovieScalingModeAspectFit;
	
	//movieplayer.view.bounds = CGRectMake(100, 100, 0, 0);
	[movieplayer.view setFrame: CGRectMake(20, 20, 533, 400)];
}


- (IBAction) enterFullscreen: (id) sender{
	if (vgaSwitch.on == NO) {
		movieplayer.fullscreen = YES;
		movieplayer.controlStyle = MPMovieControlStyleEmbedded;
	}
}

- (void) willExitFullscreen {
	movieplayer.controlStyle = MPMovieControlStyleNone;
	if (vgaSwitch.on == NO) {
		[movieplayer pause];

	}
}
	
	
-(IBAction) flickedVGASwitch: (id) sender{	
	if (vgaSwitch.on == NO) {
			movieplayer.fullscreen = NO;
			[movieplayer release];
			movieplayer = nil;
			[self movieplayerAlloc: currentMovie movieExtension:currentMovieExtension];
			[self.view addSubview:movieplayer.view];
	}
	else{	
		if ([[UIScreen screens] count] > 1) {
			[self log:@"Found an external screen."];
		
			// Internal display is 0, external is 1.
			externalScreen = [[[UIScreen screens] objectAtIndex:1] retain];
			[self log:[NSString stringWithFormat:@"External screen: %@", externalScreen]];
		
			screenModes = [externalScreen.availableModes retain];
			[self log:[NSString stringWithFormat:@"Available modes: %@", screenModes]];
		
			// Allow user to choose from available screen-modes (pixel-sizes).
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"External Display Size" 
														 message:@"Choose a size for the external display." 
														delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:nil] autorelease];
			for (UIScreenMode *mode in screenModes) {
				CGSize modeScreenSize = mode.size;
				[alert addButtonWithTitle:[NSString stringWithFormat:@"%.0f x %.0f pixels", modeScreenSize.width, modeScreenSize.height]];
			}
			[alert show];
		
		} else {
			[self log:@"External screen not found."];
		}
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIScreenMode *desiredMode = [screenModes objectAtIndex:buttonIndex];
	[self log:[NSString stringWithFormat:@"Setting mode: %@", desiredMode]];
	externalScreen.currentMode = desiredMode;
	
	[self log:@"Assigning externalWindow to externalScreen."];
	externalWindow.screen = externalScreen;
	
	[screenModes release];
	[externalScreen release];
	
	CGRect rect = CGRectZero;
	rect.size = desiredMode.size;
	externalWindow.frame = rect;
	externalWindow.clipsToBounds = YES;
	
	[self log:@"Displaying externalWindow on externalScreen."];
	externalWindow.hidden = NO;

	[externalWindow makeKeyAndVisible];
	
	[movieplayer release];
	movieplayer = nil;
	
	[self movieplayerAlloc: currentMovie movieExtension:currentMovieExtension];
	
	[externalWindow addSubview:movieplayer.view];
	movieplayer.fullscreen = YES;
	[movieplayer pause];
}

- (void)log:(NSString *)msg
{
	[consoleTextView setText:[consoleTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@\r\r", msg]]];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (IBAction) playMovie: (id) sender
{
	movieplayer.currentPlaybackRate = playbackRateSlider.value;
	[movieplayer play];	
}

- (IBAction) pauseMovie: (id) sender
{
	[movieplayer pause];
	if(swingSwitch.on == NO){
		//NSDate *end = [NSDate date];
		//NSTimeInterval interval = [end timeIntervalSinceDate:self.start];
		//NSLog(@"Elapsed time: %f", (float) interval);
		playbackPositionSlider.value=(movieplayer.currentPlaybackTime)/(movieplayer.duration);
	}
}

- (IBAction) changeMovie: (id) sender
{
	if(swingSwitch.on == NO) {
		UIActionSheet *changeMovieActionSheet = [[[UIActionSheet alloc] initWithTitle: @"Change Movie?" 
												  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:
												  nil otherButtonTitles:@"Bullet 4000", @"Glasgow 4000",
												  @"Glasgow 5000", @"Superman 4000", nil] autorelease];
		[changeMovieActionSheet showInView:self.view];
	}
}

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (NSInteger) buttonIndex {
	NSLog(@"buttons index: %i", buttonIndex); 
	
	if(buttonIndex == 0) {
		currentMovie = [NSString stringWithFormat:@"Bullet_4000"];
		currentMovieExtension = [NSString stringWithFormat:@"mov"];
	}
	else if(buttonIndex == 1) {
		currentMovie = [NSString stringWithFormat:@"Glasgow_4000"];
		currentMovieExtension = [NSString stringWithFormat:@"mov"];
	}
	else if (buttonIndex == 2) {
		currentMovie = [NSString stringWithFormat:@"Glasgow_5000"];
		currentMovieExtension = [NSString stringWithFormat:@"mov"];
	}
	else if (buttonIndex == 3) {
		currentMovie = [NSString stringWithFormat:@"Superman_4000"];
		currentMovieExtension = [NSString stringWithFormat:@"mov"];
	}
	
	if(buttonIndex != [actionSheet cancelButtonIndex]) {
		NSLog(@"cancelled...");
		[movieplayer release];
		movieplayer = nil;		
		[self movieplayerAlloc: currentMovie movieExtension:currentMovieExtension];
		[self.view addSubview:movieplayer.view]; [self resetSliders];
	}
}


- (void) playingDone {
	if(swingSwitch.on == NO){
		if(movieplayer.currentPlaybackTime > 0) {
			playbackPositionSlider.value = 1; 
			[NSString stringWithFormat:@"%.2f", playbackPositionSlider.value];
		}
		else {
			playbackPositionSlider.value = 0; 
			[NSString stringWithFormat:@"%.2f", playbackPositionSlider.value];
		}
	}
}


-(IBAction) updatePlaybackPositionFromSlider: (id) sender {
	double tmp;
	tmp = movieplayer.duration*((double) playbackPositionSlider.value);
	movieplayer.currentPlaybackTime = tmp;
	playbackPositionLabel.text = [NSString stringWithFormat:@"%.2f", playbackPositionSlider.value];
	[movieplayer pause];
}

-(IBAction) updatePlaybackRateFromSlider: (id) sender {
	playbackRateLabel.text = [NSString stringWithFormat:@"%.2f", playbackRateSlider.value];	
//	movieplayer.currentPlaybackRate = playbackRateSlider.value;
}


-(IBAction) updateUpdateIntervalFromSlider: (id) sender {
	updateIntervalLabel.text = [NSString stringWithFormat:@"%.2f", updateIntervalSlider.value];
	self.accelerometer.updateInterval = updateIntervalSlider.value;
}


-(IBAction) updateVelocitySensitivityFromSlider: (id) sender {
	velocitySensitivityLabel.text = [NSString stringWithFormat:@"%.1f", velocitySensitivitySlider.value];
}

-(IBAction) updateResetThresholdFromSlider: (id) sender {
	resetThresholdLabel.text = [NSString stringWithFormat:@"%.2f", resetThresholdSlider.value];
}

-(IBAction) updateResetIntervalFromSlider: (id) sender {
	resetIntervalLabel.text = [NSString stringWithFormat:@"%.0f", resetIntervalSlider.value];
}

- (IBAction) resetSlidersTouch: (id)sender {
	[self resetSliders];
	self.accelerometer.updateInterval = updateIntervalSlider.value;
}


- (void) smoothXYZ {
	if (velX==999) {
		smoothX = nowX; smoothY = nowY; smoothZ = nowZ;
	}
	else {
		smoothX = (nowX+prevX)/2;smoothY = (nowY+prevY)/2;smoothZ = (nowZ+prevZ)/2;
	}
}


- (void) calculateVelocity {
	if (velX==999){
		velX=0; velY=0; velZ=0;
	}
	else {
		velX=(nowX-prevX)/(updateIntervalSlider.value); 
		velY=(nowY-prevY)/(updateIntervalSlider.value); velZ=(nowZ-prevZ)/(updateIntervalSlider.value);		
	}

	
	prevX=nowX; prevY=nowY; prevZ=nowZ;
}

- (void) smoothVelocity {

		smoothVelX = (velX+prevVelX)/2;smoothVelY = (velY+prevVelY)/2;
		smoothVelZ = (velZ+prevVelZ)/2;
}

- (float) calibratePlaybackRate: (float) rate {
 
	if (rate >= -twitchValue && rate <= twitchValue) {
		return 0;
	}
	else if (rate > twitchValue && rate <= 0.58) {
		return 0.5;
	}
	else if (rate < - twitchValue && rate >= -0.58) {
		return -0.5;
	}
	else if (rate > 0.58 && rate <= 0.73) {
		return 0.6;
	}
	else if (rate < - 0.58 && rate >= -0.73) {
		return -0.665;
	}
	else if (rate > 0.73 && rate <= 0.89) {
		return 0.8;
	}
	else if (rate < -0.73 && rate >= -0.89) {
		return -0.802;
	}
	else if (rate > 0.89 && rate <= 1.12) {
		return 1;
	}
	else if (rate < -0.89 && rate >= -1.12) {
		return -1;
	}
	else if (rate > 1.12 && rate <= 1.37) {
		return 1.2;
	}
	else if (rate < -1.12 && rate >= -1.37) {
		return -1.25;
	}
	else if (rate > 1.37 && rate <= 1.75) {
		return 1.5;
	}
	else if (rate < -1.37 && rate >= -1.75) {
		return -1.505;
	}
	else if (rate > 1.75 && rate <= 2.0) {
		return 1.9;
	}
	else if (rate < -1.75 && rate >= -2.0) {
		return -2;
	}
	else {
		return rate;
	}
	
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	nowX = acceleration.x; nowY = acceleration.y; nowZ=acceleration.z;
	[self smoothXYZ];
	
	prevVelX = velX; prevVelY = velY; prevVelZ = velZ;
	[self calculateVelocity];
	[self smoothVelocity];
	
	if (readoutSwitch.on==YES) {
		labelX.text = [NSString stringWithFormat:@"%.2f",  smoothX];
		labelY.text = [NSString stringWithFormat:@"%.2f",  smoothY];
		labelZ.text = [NSString stringWithFormat:@"%.2f",  smoothZ];
		labelvelX.text = [NSString stringWithFormat:@"%.2f",  smoothVelX];
		labelvelY.text = [NSString stringWithFormat:@"%.2f",  smoothVelY];
		labelvelZ.text = [NSString stringWithFormat:@"%.2f",  smoothVelZ];
	}
		
	if (swingSwitch.on==YES){
		if (velX < 999){
			if (XYZSegmented.selectedSegmentIndex==0) {
				movieplayer.currentPlaybackRate = 
				[self calibratePlaybackRate : (smoothVelX*(velocitySensitivitySlider.value))];
				if (smoothVelX < resetThresholdSlider.value) {
					resetTime = resetTime + updateIntervalSlider.value;
				}
				else {
					resetTime = 0; haveResetTime = 0;
				}
			}
			else if (XYZSegmented.selectedSegmentIndex==1){
				movieplayer.currentPlaybackRate =
				[self calibratePlaybackRate : (smoothVelY*(velocitySensitivitySlider.value))];
				if (smoothVelY < resetThresholdSlider.value) {
					resetTime = resetTime + updateIntervalSlider.value;
				}
				else {
					resetTime = 0; haveResetTime = 0;
				}
			}
			else if (XYZSegmented.selectedSegmentIndex==2){
				movieplayer.currentPlaybackRate = 
				[self calibratePlaybackRate : (smoothVelZ*(velocitySensitivitySlider.value))];
				if (smoothVelZ < resetThresholdSlider.value) {
					resetTime = resetTime + updateIntervalSlider.value;
				}
				else {
					resetTime = 0; haveResetTime = 0;
				}
			}
			
			if (resetTime > resetIntervalSlider.value && haveResetTime ==0 && resetIntervalSlider.value > 0){
				if (randomSegmented.selectedSegmentIndex == 0){
					movieplayer.currentPlaybackTime = movieplayer.duration*((double) playbackPositionSlider.value);
				}
				else if (randomSegmented.selectedSegmentIndex ==1) {
					double randMovPos = ((float)rand())/((float)RAND_MAX);
					movieplayer.currentPlaybackTime = movieplayer.duration*(randMovPos);
					playbackPositionSlider.value = randMovPos;
					//NSLog(@"RAND MAX IS%f", randMovPos);
				}
				resetTime = 0; 
				haveResetTime = 1;
			}
		}	
	}
}


-(IBAction) flickedSwingSwitch: (id) sender{
	if(swingSwitch.on==NO) {
		playbackRateSlider.value=movieplayer.currentPlaybackRate;
		playbackRateLabel.text = [NSString stringWithFormat:@"%.2f", playbackRateSlider.value];
		playbackPositionSlider.value=(movieplayer.currentPlaybackTime)/(movieplayer.duration);
		playbackPositionLabel.text = [NSString stringWithFormat:@"%.2f", playbackPositionSlider.value];
		[movieplayer pause];
	}
}


-(IBAction) flickedReadoutSwitch: (id) sender{
	resetTime = 0; haveResetTime = 0;
	if(readoutSwitch.on==NO) {
		labelX.text = [NSString stringWithFormat:@"N/A"];
		labelY.text = [NSString stringWithFormat:@"N/A"];
		labelZ.text = [NSString stringWithFormat:@"N/A"];
		labelvelX.text = [NSString stringWithFormat:@"N/A"];
		labelvelY.text = [NSString stringWithFormat:@"N/A"];
		labelvelZ.text = [NSString stringWithFormat:@"N/A"];
	}
}

-(IBAction) flickedTwitchSwitch: (id) sender{
	if(twitchSwitch.on == YES) {
		twitchValue = 0.01;
	}
	else {
		twitchValue =0.1;
	}
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[movieplayer release];
	
	[currentMovie release];
	[currentMovieExtension release];
		
	[playbackPositionSlider release];
	[playbackRateSlider release];
	[velocitySensitivitySlider release];
	[updateIntervalSlider release];
	[resetThresholdSlider release];
	[resetIntervalSlider release];

	[labelX release]; [labelvelX release];
	[labelY release]; [labelvelY release];
	[labelZ release]; [labelvelZ release];
	[playbackPositionLabel release];
	[velocitySensitivityLabel release];
	[updateIntervalLabel release];
	[resetThresholdLabel release];
	[resetIntervalLabel release];
	
	[swingSwitch release];
	[readoutSwitch release];
	[twitchSwitch release];
	
	[XYZSegmented release];
	[randomSegmented release];
	
	[accelerometer release];
	
  	[consoleTextView release];
	[externalWindow release];
	[vgaSwitch release];
	
	[super dealloc];	
}

@end
