// This is console C program converting BDIP file into text file.
// This program is used in hns_meg3.lsp as
// (system "read_bdip target_file output_file");

#include <stdio.h>
#include <stdint.h>
#include <string.h>

float getpfloat(unsigned char *pb, int n){
    float x;
    *((unsigned char *)&x)    =pb[n+3];
    *(((unsigned char *)&x)+1)=pb[n+2];
    *(((unsigned char *)&x)+2)=pb[n+1];
    *(((unsigned char *)&x)+3)=pb[n];
    return x;
}

int32_t getpint(unsigned char *pb, int n){
    int32_t x;
    *((unsigned char *)&x)    =pb[n+3];
    *(((unsigned char *)&x)+1)=pb[n+2];
    *(((unsigned char *)&x)+2)=pb[n+1];
    *(((unsigned char *)&x)+3)=pb[n];
    return x;
}

int main(int argc, char *argv[]) {
    int i=0;
    unsigned char b[196];
    int32_t dip,error_computed;
    float begin,end;
    float r0[3],r[3],Q[3];
    float gof,conf_vol;
    // file open
    FILE *inputFile = fopen(argv[1], "rb"); // argv[0] is function itself
    FILE *outputFile = fopen(argv[2], "w"); // output as text file

    if (inputFile == NULL || outputFile == NULL) {
        printf("Impossible to open target file。\n");
        return 1;
    }

    // reading BDIP file
    while (fread(b,sizeof(unsigned char),196,inputFile)>0){
        //dip  =getpint(b,0);
        begin=getpfloat(b,4);
        end  =getpfloat(b,8);
        r0[0]=getpfloat(b,12);
        r0[1]=getpfloat(b,16);
        r0[2]=getpfloat(b,20);
        r[0] =getpfloat(b,24);
        r[1] =getpfloat(b,28);
        r[2] =getpfloat(b,32);
        Q[0] =getpfloat(b,36);
        Q[1] =getpfloat(b,40);
        Q[2] =getpfloat(b,44);
        gof  =getpfloat(b,48);
        error_computed=getpint(b,52);
        conf_vol=getpfloat(b,180);
    
        begin=begin*1e+3;
        end=end*1e+3;
        //r[0]=r[0]*1e+3;
        //r[1]=r[1]*1e+3;
        //r[2]=r[2]*1e+3;
        Q[0]=Q[0]*1e+9;
        Q[1]=Q[1]*1e+9;
        Q[2]=Q[2]*1e+9;
        gof=gof*1e+2;

         // data output
        fprintf(outputFile,"%f %f %f %f %f ",begin,end,r[0],r[1],r[2]);
        fprintf(outputFile,"%f %f %f %f %f \n",Q[0],Q[1],Q[2],gof,conf_vol);
        i++;
    }

    // file closure
    fclose(inputFile);
    fclose(outputFile);

    printf("Target file is loaded without trouble\n");

    return 0;
}