//
//  DesparatePadViewController.h
//  DesparatePad
//
//  Created by Vid Stojevic on 22/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaPlayback.h>

@interface DesparatePadViewController : UIViewController <UIAccelerometerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
	MPMoviePlayerController * movieplayer;
	
	NSString * currentMovie; NSString * currentMovieExtension;
	
	IBOutlet UISlider * playbackPositionSlider;
	IBOutlet UISlider * playbackRateSlider;
	IBOutlet UISlider * velocitySensitivitySlider;
	IBOutlet UISlider * updateIntervalSlider;
	IBOutlet UISlider * resetThresholdSlider;
	IBOutlet UISlider * resetIntervalSlider;

	IBOutlet UILabel * labelX;
	IBOutlet UILabel * labelY;
	IBOutlet UILabel * labelZ;
	IBOutlet UILabel * labelvelX;
	IBOutlet UILabel * labelvelY;
	IBOutlet UILabel * labelvelZ;
	IBOutlet UILabel * updateIntervalLabel;
	IBOutlet UILabel * playbackPositionLabel;
	IBOutlet UILabel * playbackRateLabel;
	IBOutlet UILabel * velocitySensitivityLabel;
	IBOutlet UILabel * resetThresholdLabel;
	IBOutlet UILabel * resetIntervalLabel;
	
	IBOutlet UISwitch * swingSwitch;
	IBOutlet UISwitch * readoutSwitch;
	IBOutlet UISwitch * twitchSwitch;
	
	IBOutlet UISegmentedControl *XYZSegmented;
	IBOutlet UISegmentedControl *randomSegmented;

	UIAccelerometer *accelerometer;

	float prevX; float nowX;	float smoothX;
	float prevY; float nowY;	float smoothY;
	float prevZ; float nowZ;	float smoothZ;
	float velX; float prevVelX; float smoothVelX;
	float velY; float prevVelY; float smoothVelY;
	float velZ; float prevVelZ; float smoothVelZ;
	
	float resetTime; bool haveResetTime;
	
	float twitchValue;
 	
	UIScreen *externalScreen;
	UIWindow *externalWindow;
	UITextView *consoleTextView;
	NSArray *screenModes;
	UISwitch *vgaSwitch;
	
//	NSDate * start;
	
}

//@property (nonatomic, retain) NSDate * start;

@property (nonatomic, retain) MPMoviePlayerController * movieplayer;
@property (nonatomic, retain) NSString *currentMovie;
@property (nonatomic, retain) NSString *currentMovieExtension;

@property (nonatomic, retain) UISlider * playbackPositionSlider;
@property (nonatomic, retain) UISlider * playbackRateSlider;
@property (nonatomic, retain) UISlider * velocitySensitivitySlider;
@property (nonatomic, retain) UISlider * updateIntervalSlider;
@property (nonatomic, retain) UISlider * resetThresholdSlider;
@property (nonatomic, retain) UISlider * resetIntervalSlider;

@property (nonatomic, retain) UISegmentedControl * XYZSegmented;
@property (nonatomic, retain) UISegmentedControl * randomSegmented;

@property (nonatomic, retain) IBOutlet UILabel *labelX;
@property (nonatomic, retain) IBOutlet UILabel *labelY;
@property (nonatomic, retain) IBOutlet UILabel *labelZ;
@property (nonatomic, retain) IBOutlet UILabel *labelvelX;
@property (nonatomic, retain) IBOutlet UILabel *labelvelY;
@property (nonatomic, retain) IBOutlet UILabel *labelvelZ;
@property (nonatomic, retain) IBOutlet UILabel *playbackPositionLabel;
@property (nonatomic, retain) IBOutlet UILabel *playbackRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *velocitySensitivityLabel;
@property (nonatomic, retain) IBOutlet UILabel *updateIntervalLabel;
@property (nonatomic, retain) IBOutlet UILabel *resetThresholdLabel;
@property (nonatomic, retain) IBOutlet UILabel *resetIntervalLabel;

@property (nonatomic, retain) IBOutlet UISwitch *swingSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *readoutSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *twitchSwitch;

@property (nonatomic, retain) UIAccelerometer *accelerometer;

@property (nonatomic, retain) IBOutlet UIWindow *externalWindow;
@property (nonatomic, retain) IBOutlet UITextView *consoleTextView;
@property (nonatomic, retain) IBOutlet UISwitch * vgaSwitch;

-(void) movieplayerAlloc: (NSString *) movieName movieExtension: (NSString *) extension;

//Notifications
-(void) playingDone;
-(void) willExitFullscreen;

-(void) smoothXYZ;
-(void) calculateVelocity;
-(void) smoothVelocity;

-(IBAction) playMovie: (id) sender;
-(IBAction) pauseMovie: (id) sender;
-(IBAction) enterFullscreen: (id) sender;
-(IBAction) changeMovie: (id) sender;

-(IBAction) updatePlaybackPositionFromSlider: (id) sender;
-(IBAction) updatePlaybackRateFromSlider: (id) sender;
-(IBAction) updateUpdateIntervalFromSlider: (id) sender;
-(IBAction) updateVelocitySensitivityFromSlider: (id) sender;
-(IBAction) updateResetThresholdFromSlider: (id) sender;
-(IBAction) updateResetIntervalFromSlider: (id) sender;

-(IBAction) resetSlidersTouch: (id) sender;


-(IBAction) flickedSwingSwitch: (id) sender;
-(IBAction) flickedReadoutSwitch: (id) sender;
-(IBAction) flickedVGASwitch: (id) sender;
-(IBAction) flickedTwitchSwitch: (id) sender;

-(void) resetSliders;

-(void)log:(NSString *)msg;

-(float) calibratePlaybackRate: (float) rate;


@end

