//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timerPicker;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) int seconds;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isStarted;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerLabel.hidden = YES;
    self.pauseButton.enabled = NO;
    self.pauseButton.layer.cornerRadius = 40;
    self.pauseButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.pauseButton.layer.borderWidth = 1;
    self.startButton.layer.cornerRadius = 40;
    self.startButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.startButton.layer.borderWidth = 1;
}

- (IBAction)startButtonTapped:(id)sender
{
    UIButton *button = sender;
    self.timerLabel.hidden = !self.timerLabel.hidden;
    self.timerPicker.hidden = !self.timerPicker.hidden;
    
    if ([button.titleLabel.text isEqualToString:@"Start"]) {
        [button setTitle:@"Cancel" forState:UIControlStateNormal];
        self.pauseButton.enabled = YES;
        self.isStarted = YES;
        self.seconds = [@(self.timerPicker.countDownDuration) intValue];
        //self.timerLabel.text = [NSString stringWithFormat:@"%d", self.seconds];
        [self displayTime];
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                               target:self
                                                             selector:@selector(countDown)
                                                             userInfo:nil
                                                              repeats:YES];
        
    } else {
        [button setTitle:@"Start" forState:UIControlStateNormal];
        self.pauseButton.enabled = NO;
        self.isStarted = NO;
        self.seconds = 0;
        [self displayTime];
        [self.countDownTimer invalidate];
    }
}

- (IBAction)pauseButtonTapped:(id)sender
{
    UIButton *button = sender;

    if (self.isPaused) {
        [button setTitle:@"Pause" forState:UIControlStateNormal];
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                               target:self
                                                             selector:@selector(countDown)
                                                             userInfo:nil
                                                              repeats:YES];
    } else {
        [button setTitle:@"Resume" forState:UIControlStateNormal];
        [self.countDownTimer invalidate];
    }
    self.isPaused = !self.isPaused;
}

- (void)countDown
{
    self.seconds--;
    if (self.seconds <= 0) {
        [self.countDownTimer invalidate];
    }
    [self displayTime];
}

- (void)displayTime
{
    int hour = self.seconds / 3600;
    int minute = (self.seconds % 3600) / 60;
    int second = (self.seconds % 3600) % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if  (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        self.timerLabel.hidden = NO;
        self.timerLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:130];
    } else {
        self.timerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
        if (!self.isStarted) {
            self.timerLabel.hidden = YES;
        } else {
            self.timerLabel.hidden = NO;
        }
    }
}

@end
