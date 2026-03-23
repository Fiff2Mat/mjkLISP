// This is console C program converting BDIP file into text file.
// This program is used in hns_meg3.lsp as
// (system "read_bdip target_file output_file");

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
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
    int i = 0;
    unsigned char b[196];
    int32_t dip,error_computed=0;
    float begin, end=0;
    float r0[3],r[3],Q[3];
    float gof, conf_vol, khi2=0.0;
    float prob;
    // file open  argv[0] is function itselt
    FILE *inputTEXT = fopen(argv[1], "r");  // N x float[10] text
    FILE *inputBDIP = fopen(argv[2], "rb");  //
    FILE *outputBDIP = fopen(argv[3], "wb"); // 
    char line[1024];
    int  n,row = 0;
    float (*BDIP)[10] = NULL;//BDIP[][10]
    float val[10];
    int   check;

    // reading TEXT file
    if (inputTEXT == NULL){
        printf("Impossible to open target TXT file\n");
        return 1;
    }
    while(fgets(line,sizeof(line),inputTEXT)){
	n = sscanf(line,"%f %f %f %f %f %f %f %f %f %f",
	     &val[0],&val[1],&val[2],&val[3],&val[4],
             &val[5],&val[6],&val[7],&val[8],&val[9]);
        if(n!=10){
	  fprintf(stderr,"The %d th row does not contain 10 atoms\n", row+1);
            continue;
        }  

        float (*tmp)[10]=realloc(BDIP,(row+1)*sizeof(*BDIP));
        if(!tmp){
          perror("realloc");
          free(BDIP);
          fclose(inputTEXT);
          return 1;
        }
        BDIP = tmp;
        for(i=0;i<10;i++){BDIP[row][i]=val[i];}
        row++;
    }
    fclose(inputTEXT);
    printf("TXT file is loaded without trouble.\n");

    /*
    for(i=0;i<row;i++){
        printf("Row: %d",i);
        for(n=0;n<10;n++){
	  printf(" %0.2f",BDIP[i][n]);
        }
        printf("\n");
    }
    */

    // reading BDIP file
    if (inputBDIP == NULL || outputBDIP == NULL) {
        printf("Impossible to open target BDIP file\n");
        return 1;
    }

    while (fread(b,sizeof(unsigned char),196,inputBDIP)>0){
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
        getfloat(&b[188],&prob);
    
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

        //dipole selection
        check=0;
        for(i=0;i<row;i++){
          if(abs(BDIP[i][0]-begin)<0.1){
            if(abs(BDIP[i][1]-r[0])<0.1){
              if(abs(BDIP[i][2]-r[1])<0.1){
	        if(abs(BDIP[i][3]-r[2])<0.1){
                  if(abs(BDIP[i][4]-Q[0])<0.1){
                    if(abs(BDIP[i][5]-Q[1])<0.1){
                      if(abs(BDIP[i][6]-Q[2])<0.1){
                        if(abs(BDIP[i][7]-gof)<0.1){
                          if(abs(BDIP[i][8]-conf_vol)<0.1){
			    if(abs(BDIP[i][9]-khi2)<0.01){
                              check=1;
                              break;}}}}}}}}}}}
        if(check==1){
            fwrite(b,sizeof(unsigned char),196,outputBDIP);
        }
        i++;


    }

    // file closure
    fclose(inputBDIP);
    fclose(outputBDIP);

    printf("Target dipoles were selected without trouble\n");

    return 0;
}
