//
//  WavAmrCodec.cpp
//  VoiceRP
//
//  Created by liewli on 6/25/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#include "WavAmrCodec.h"
#include "wavwriter.h"
#include "wavreader.h"
#include "interf_dec.h"
#include "interf_enc.h"
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


const int sizes[] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 6, 5, 5, 0, 0, 0, 0 };

inline int __min(int a, int b) {return a < b ? a : b;}

bool amr_decode(const char * src_amr_path, const char *dst_wav_path) {
    FILE *in = fopen(src_amr_path, "rb");
    
    if (!in) {
        printf("decode error: cannot open amr file\n");
        return false;
    }
    
    char header[6];
    int n = fread(header, 1, 6, in);
    if (n != 6 || memcmp(header, "#!AMR\n", 6))
    {
        printf("Bad header\n");
    }
    
   // WavWriter wav("out.wav", 8000, 16, 1);
    void *wav =  wav_write_open(dst_wav_path, 8000, 16, 1);
    if (!wav) {
        printf("decode error: cannot create wav file\n");
        fclose(in);
        return false;
    }
    void* amr = Decoder_Interface_init();
    int frame = 0;
    
    
    unsigned char stdFrameHeader = 0;
    
    while (true) {
        uint8_t buffer[500];
        /* Read the mode byte */
        
        unsigned char frameHeader;
        int size;
        int index;
        if (frame == 0)
        {
            n = fread(&stdFrameHeader, 1, sizeof(unsigned char), in);
            index = (stdFrameHeader >> 3) &0x0f;
        }
        else
        {
            while(1)   //丢弃错误帧，处理正确帧
            {
                n = fread(&frameHeader, 1, sizeof(unsigned char), in);
                if (feof(in))  goto clear;
                if (frameHeader == stdFrameHeader) break;
            }
            index = (frameHeader >> 3) & 0x0f;
        }
        
        if (n <= 0)
            break;
        /* Find the packet size */
        size = sizes[index];
        if (size <= 0)
            break;
        n = fread(buffer + 1, 1, size, in);
        if (n != size)
            break;
        
        frame++;
        /* Decode the packet */
        int16_t outbuffer[160];
        Decoder_Interface_Decode(amr, buffer, outbuffer, 0);
        
        /* Convert to little endian and write to wav */
        uint8_t littleendian[320];
        uint8_t* ptr = littleendian;
        for (int i = 0; i < 160; i++) {
            *ptr++ = (outbuffer[i] >> 0) & 0xff;
            *ptr++ = (outbuffer[i] >> 8) & 0xff;
        }
        //wav.writeData(littleendian, 320);
        wav_write_data(wav, littleendian, 320);
    }
    printf("frame=%d\n", frame);
clear:
    fclose(in);
    wav_write_close(wav);
    Decoder_Interface_exit(amr);
    return true;
    
}

bool amr_encode(const char * src_wav_path, const char *dst_amr_path) {
    FILE *out = fopen(dst_amr_path, "wb");
    if (!out) {
        printf("encode error: cannot create amr file\n");
        return false;
    }
    void *wav = wav_read_open(src_wav_path);
    if (!wav) {
        printf("encode error: cannnot read wav file\n");
        fclose(out);
        return false;
    }
    int format;
    int channels;
    int sampleRate;
    int bitsPerSample;
    unsigned int dataLength;
    
    wav_get_header(wav, &format, &channels, &sampleRate, &bitsPerSample, &dataLength);
    if (format != 1 || channels != 1 || sampleRate != 8000 || bitsPerSample != 16 || dataLength == 0) {
        fclose(out);
        wav_read_close(wav);
        printf("encode error: wav format not supported\n");
               return false;
    }
    printf("wav format: format:%d channels:%d sampleRate:%d bitsPerSample:%d dataLength:%d\n", format, channels, sampleRate, bitsPerSample, dataLength);

    
    
    void *amr = Encoder_Interface_init(0);
    fwrite("#!AMR\n", 1, 6, out);
    
    int inputSize = channels * 2 * 160;
    uint8_t *inputBuf = (uint8_t *)malloc(inputSize);
    
    while (1) {
        short buf[160] = {0};
        uint8_t outbuf[500];
        int read = wav_read_data(wav, inputBuf, inputSize);
        read /= channels;
        read /= 2;
        if (read < 160) {
            break;
        }
        for (int i = 0; i < 160; i++) {
            const uint8_t *input = &inputBuf[2*channels*i];
            buf[i] = input[0] | (input[1] << 8);
        }
        int n = Encoder_Interface_Encode(amr, MR475, buf, outbuf, 0);
        fwrite(outbuf, 1, n, out);
    }
    
clear:
    free(inputBuf);
    fclose(out);
    Encoder_Interface_exit(amr);
    wav_read_close(wav);
    return true;
}