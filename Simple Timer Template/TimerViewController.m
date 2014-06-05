//
//  TimerViewController.m
//  Simple Timer Template
//
//  Created by Lasse Iversen
//

#import "TimerViewController.h"
#import "ESTBeaconManager.h"

@interface TimerViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;

// Stopwatch Components
@property (weak, nonatomic) NSTimer *myTimer;
@property int currentTimeInSeconds;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation TimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup Estimote beacon manager
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion * region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimtoe beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    // Checks if there is any beacons available and find the closests one, then starts the timer.
    if (beacons.count > 0 && !_myTimer)
    {
        [self startTimer];
        
        self.timerLabel.text = [self formattedTime:_currentTimeInSeconds];
    }
    else if(beacons.count == 0 && _myTimer)
    {
        [self stopTimer];
        
        _currentTimeInSeconds = 0;
        
        self.timerLabel.text = @"No beacon around";
    }
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    
    _currentTimeInSeconds++;
    
    _timerLabel.text = [self formattedTime:_currentTimeInSeconds];
    
}

- (NSString *)formattedTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)startTimer {
    
    if (!_currentTimeInSeconds) {
        _currentTimeInSeconds = 0 ;
    }
    
    if (!_myTimer) {
        _myTimer = [self createTimer];
    }
}

- (void)stopTimer {
    
    [_myTimer invalidate];
}

- (void)resetTimer {
    
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = [self createTimer];
    }
    
    _currentTimeInSeconds = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

@end
