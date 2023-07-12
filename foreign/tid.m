#import "tid.h"
#import <LocalAuthentication/LocalAuthentication.h>

void* create_la_context(void) {
    return (__bridge void*)[[LAContext alloc] init];
}

void retain_la_context(void* ctx) {
    [(__bridge LAContext*)ctx retain];
}

void drop_la_context(void* ctx) {
    [(__bridge LAContext*)ctx release];
}

void set_localized_cancel_title(void* ctx, char* reason) {
    NSString *titleString = [[NSString alloc] initWithCString:reason encoding:NSUTF8StringEncoding];
    [(__bridge LAContext*)ctx setLocalizedCancelTitle:titleString];
    [titleString release];
}

int32_t can_evaluate_policy(void *ctx, int32_t policy) {
    BOOL result = [(__bridge LAContext*)ctx canEvaluatePolicy:(LAPolicy)policy error:nil];
    return result;
}

int32_t set_credential(void* ctx, char* credential) {
    NSString *credentialString = [[NSString alloc] initWithCString:credential encoding:NSUTF8StringEncoding];
     NSData *credentialData = [credentialString dataUsingEncoding:NSUTF8StringEncoding];
    BOOL result = [(__bridge LAContext*)ctx setCredential:credentialData type:LACredentialTypeApplicationPassword];
    [credentialString release];
    return result;
}

void evaluate_policy(void* ctx, int32_t policy, char* reason, void* future, void* callback) {
    NSString* reasonString = [[NSString alloc] initWithCString:reason encoding:NSUTF8StringEncoding];
    [
        (__bridge LAContext*)ctx
        evaluatePolicy:(LAPolicy)policy
        localizedReason:reasonString
        reply:^(BOOL success, NSError *error) {
            if (!success && error != nil) {
                ((void (*)(void*, BOOL, int32_t))callback)(future, success, (int32_t)error.code);
            } else if (success && error == nil) {
                ((void (*)(void*, BOOL, int32_t))callback)(future, success, 0);
            }
        }
    ];
  [reasonString release];
}

void evaluate_access_control(void* ctx, void* access_control, char* reason, void* future, void* callback) {
    NSString* reasonString = [[NSString alloc] initWithCString:reason encoding:NSUTF8StringEncoding];
    [
        (__bridge LAContext*)ctx
        evaluateAccessControl:(SecAccessControlRef)access_control
        operation:LAAccessControlOperationUseItem
        localizedReason:reasonString
        reply:^(BOOL success, NSError *error) {
            if (!success && error != nil) {
                ((void (*)(void*, BOOL, int32_t))callback)(future, success, (int32_t)error.code);
            } else if (success && error == nil) {
                ((void (*)(void*, BOOL, int32_t))callback)(future, success, 0);
            }
        }
    ];
  [reasonString release];
}
