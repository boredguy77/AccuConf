//
//  ConferenceLineDetailViewController.m
//  AccuConference2
//
//  Created by Alex Telford on 8/24/13.
//  Copyright (c) 2013 Alex Telford. All rights reserved.
//

#import "ConferenceLineDetailViewController.h"
@implementation ConferenceLineDetailViewController

@synthesize conferenceLine, nameLabel, numberLabel, moderatorLabel, participantLabel, callButton, createConferenceButton, shareLineButton, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.conferenceLine){
        [self populateUIWithConferenceLine:self.conferenceLine];
    }
}

-(void)conferenceLineEdited:(NSNotification *)notification{
    NSLog(@"ConferenceLineEdited");
    ConferenceLine *line = (ConferenceLine *) [notification.userInfo objectForKey:@"conferenceLine"];
    [self populateUIWithConferenceLine:line];
}

-(void)populateUIWithConferenceLine:(ConferenceLine *)line{
    self.title = line.name;
    self.nameLabel.text = line.name;
    self.numberLabel.text = line.number;
    self.moderatorLabel.text = line.moderatorCode;
    self.participantLabel.text = line.participantCode;
    if(line.conferences.count > 0){
        [self.table reloadData];
    } else {
        self.table.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setConferenceLine:(ConferenceLine *)line{
    NSLog(@"setConferenceLine");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONFERENCE_LINE_UPDATED object:conferenceLine];
    conferenceLine = line;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conferenceLineEdited:) name:CONFERENCE_LINE_UPDATED object:nil];
    
}

#pragma mark - IBActions
-(void)editPressed{
    [self performSegueWithIdentifier:@"toAddEditConferenceLine" sender:self.conferenceLine];
}

-(void)createConferencePressed{
    
}

-(void)callInPressed{
    
}

-(void)shareLinePressed{
    
}

#pragma mark - TableView Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning flesh out Conference Rows
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = @"Conference Call Name";
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conferenceLine.conferences.count;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[AddEddConferenceLinesViewController class]]){
        AddEddConferenceLinesViewController *addEditController = (AddEddConferenceLinesViewController*) segue.destinationViewController;
        addEditController.conferenceLine = (ConferenceLine *) sender;
    }
}
@end
