// This is console C program converting BDIP file into text file.
// This program is used in hns_meg3.lsp as
// (system "read_bdip target_file output_file");

#include <stdio.h>
#include <stdint.h>
#include <string.h>

void getfloat(unsigned char* pb, float* pa){
    unsigned char* ppa=(unsigned char*)pa;
    *(ppa+0)=*(pb+3);
    *(ppa+1)=*(pb+2);
    *(ppa+2)=*(pb+1);
    *(ppa+3)=*(pb+0);
}

void getfloat3(unsigned char* pb, float* pa){
    unsigned char* ppa=(unsigned char*)pa;
    int32_t n;
    for(n=0;n<3;n++){
        *(ppa+0)=*(pb+3);
        *(ppa+1)=*(pb+2);
        *(ppa+2)=*(pb+1);
        *(ppa+3)=*(pb+0);
        pb=pb+4;
        ppa=ppa+4;
    }
}

void getint32(unsigned char* pb, int32_t* pa){
    unsigned char* ppa=(unsigned char*)pa;
    *(ppa+0)=*(pb+3);
    *(ppa+1)=*(pb+2);
    *(ppa+2)=*(pb+1);
    *(ppa+3)=*(pb+0);
}

int main(int argc, char *argv[]) {
    int i=0;
    unsigned char b[196];
    int32_t dip,error_computed=0;
    float begin, end=0;
    float r0[3],r[3],Q[3];
    float gof, conf_vol, khi2=0.0;
    // file open
    FILE *inputFile = fopen(argv[1], "rb"); // argv[0] is function itself
    FILE *outputFile = fopen(argv[2], "w"); // output as text file

    if (inputFile == NULL || outputFile == NULL) {
        printf("Impossible to open target file。\n");
        return 1;
    }

    // reading BDIP file
    while (fread(b,sizeof(unsigned char),196,inputFile)>0){
        getint32(&b[0],&dip);
        getfloat(&b[4],&begin);
        getfloat(&b[8],&end);
        getfloat3(&b[12],r0);
        getfloat3(&b[24],r);
        getfloat3(&b[36],Q);
        getfloat(&b[48],&gof);
        getint32(&b[52],&error_computed);
        getfloat(&b[180],&conf_vol);
        getfloat(&b[184],&khi2);
    
        begin=begin*1e+3;// msec
        end=end*1e+3;// msec
        r0[0]=r0[0]*1e+3;//mm
        r0[1]=r0[1]*1e+3;//mm
        r0[2]=r0[2]*1e+3;//mm
        r[0]=r[0]*1e+3;// mm
        r[1]=r[1]*1e+3;// mm
        r[2]=r[2]*1e+3;// mm
        Q[0]=Q[0]*1e+9;//nAm
        Q[1]=Q[1]*1e+9;//nAm
        Q[2]=Q[2]*1e+9;//nAm
        gof=gof*1e+2;//%
        conf_vol=conf_vol*1e+9;//mm^3

         // data output
        fprintf(outputFile,"%9.1f   %5.1f   %5.1f   %4.1f   ",
                            begin,  r[0],   r[1],   r[2]);
        fprintf(outputFile,"%7.1f   %7.1f   %7.1f   %5.1f   ",
                            Q[0],   Q[1],   Q[2],   gof);
        fprintf(outputFile,"%5.1f   %9.2f   \n",
		            conf_vol,khi2);
        i++;
    }

    // file closure
    fclose(inputFile);
    fclose(outputFile);

    printf("Target file is loaded without trouble\n");

    return 0;
}
