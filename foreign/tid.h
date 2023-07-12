#ifndef TID_RS_TID_H
#define TID_RS_TID_H

#include "stdint.h"

void* create_la_context(void);
void retain_la_context(void* ctx);
void drop_la_context(void* ctx);
void set_localized_cancel_title(void* ctx, char* reason);
int32_t can_evaluate_policy(void *ctx, int32_t policy);
int32_t set_credential(void *ctx, char* credential);
void evaluate_policy(void* ctx, int32_t policy, char* reason, void* user_data, void* callback);
void evaluate_access_control(void* ctx, void* access_control, char* reason, void* future, void* callback);

#endif
