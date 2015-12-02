//
//  WavAmrCodec.h
//  VoiceRP
//
//  Created by liewli on 6/25/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#ifndef __VoiceRP__WavAmrCodec__
#define __VoiceRP__WavAmrCodec__

#include <stdio.h>


bool amr_decode(const char * src_amr_path, const char *dst_wav_path);

bool amr_encode(const char * src_wav_path, const char *dst_amr_path);

#endif /* defined(__VoiceRP__WavAmrCodec__) */
