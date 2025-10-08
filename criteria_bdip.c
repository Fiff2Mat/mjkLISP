// This is console C program converting BDIP file into text file.
// This program is used in hns_meg3.lsp or hns_meg5.lsp as
// (system "criteria_bdip target_bdip_file GOF CV KHI");

#include <stdio.h>
#include <stdint.h>
#include<stdlib.h>
#include <string.h>

void getfloat(unsigned char *pb, float *pa){
    unsigned char* ppa=(unsigned char*)pa;
    *(ppa+0)=*(pb+3);
    *(ppa+1)=*(pb+2);
    *(ppa+2)=*(pb+1);
    *(ppa+3)=*(pb+0);
}

void main(int argc, char *argv[]) {
    unsigned char *b;
    FILE *fid;
    int32_t file_size,nbdip,i=0,count=0;
    const int32_t bdipsize=196;
    float GOF,gof=0.0,begin=0.0;
    float CV,cv=0.0;
    float KHI,khi=0.0;
    
    // file open
    fid = fopen(argv[1], "rb"); // argv[0] is function itself
    if (fid==NULL){
        printf("unable to open file\n");
        return;
    }
    GOF = atof(argv[2]) / 100;       // eg 98.7%->0.987
    CV  = atof(argv[3]) /1000000000; // m^3->mm^3
    KHI = atof(argv[4]);
    if (GOF<0){GOF=-1000000.0;}
    if (CV<0) {CV =1000000.0;}
    if (KHI<0){KHI=100000000;}

    //get file size
    fseek(fid,0,SEEK_END);
    file_size=ftell(fid);
    fseek(fid,0,SEEK_SET);

    if (file_size==0){
        printf("file size is zero!\n");
        fclose(fid);
        return;
    }

    if((file_size % bdipsize) >0){
        printf("This is no BDIP file\n");
        fclose(fid);
        return;
    }

    nbdip=file_size / bdipsize;

    // obtain size of b[]
    b=(unsigned char*)malloc(file_size);
    if (b==NULL){
        printf("unable to allocate memory\n");
        fclose(fid);
        return;
    }

    fread(b,sizeof(unsigned char),file_size,fid);
    fclose(fid);
    fid = fopen(argv[1], "wb");
    //fid = fopen("test.bdip","wb");
    for (i=0;i<nbdip;i++){
        getfloat(&b[48+i*bdipsize],&gof);
	getfloat(&b[180+i*bdipsize],&cv);
        getfloat(&b[184+i*bdipsize],&khi);
	if (gof>=GOF){
            if (cv<=CV){
	        if (khi<=KHI){ 
                  fwrite(&b[i*bdipsize],bdipsize,1,fid);
                  count=count+1;
	      }
	    }
	}
    }               
            
    fclose(fid);
    free(b);
    printf("%d dipoles are deleted \n",nbdip-count);

    return;
}
