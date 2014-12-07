//
//  ViewController.m
//  iospurge
//
//  Created by Matt Channon on 12/7/14.
//  Copyright (c) 2014 Matt Channon. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <Photos/Photos.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self deleteAddressBook];
    [self deletePhotos];
}

- (ABAddressBookRef)deleteAddressBook {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        for ( id obj in array )
        {
            ABRecordRef ref = (__bridge ABRecordRef)obj;
            ABAddressBookRemoveRecord(addressBook, ref, nil);
        }
        
        ABAddressBookSave(addressBook, nil);
        CFRelease(addressBook);
    });
    
    return addressBook;
}

- (void)deletePhotos {
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSArray* tempArray = [result objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.count)]];
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^(void){
        [PHAssetChangeRequest deleteAssets:tempArray];
    } error:nil];
    
//    [PHPhotoLibrary performChanges:^{
//    [PHAssetChangeRequest deleteAssets:tempArray];
//    } completionHandler:nil];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
