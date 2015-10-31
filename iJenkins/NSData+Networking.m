//
//  NSData+Networking.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "NSData+Networking.h"
#import <netinet/in.h>
#include <arpa/inet.h>


@implementation NSData (Networking)


#pragma mark Converting sockaddr from NSData

- (NSInteger)port {
    NSInteger port;
    struct sockaddr *addr;
    addr = (struct sockaddr *)[self bytes];
    if(addr->sa_family == AF_INET) port = ntohs(((struct sockaddr_in *)addr)->sin_port); // IPv4 family
    else if(addr->sa_family == AF_INET6) port = ntohs(((struct sockaddr_in6 *)addr)->sin6_port); // IPv6 family
    else port = 0; // The family is neither IPv4 nor IPv6. Can't handle.
    
    return port;
}

- (NSString *)host {
    struct sockaddr *addr = (struct sockaddr *)[self bytes];
    if(addr->sa_family == AF_INET) {
        char *address = inet_ntoa(((struct sockaddr_in *)addr)->sin_addr);
        if (address) return [NSString stringWithCString:address encoding:NSUTF8StringEncoding];
    }
    else if(addr->sa_family == AF_INET6) {
        struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
        char straddr[INET6_ADDRSTRLEN];
        inet_ntop(AF_INET6, &(addr6->sin6_addr), straddr, sizeof(straddr));
        return [NSString stringWithCString:straddr encoding:NSUTF8StringEncoding];
    }
    return nil;
}


@end
