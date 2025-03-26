// select dipoles based on time.txt
// Usage select_png target.bdip input_time.txt

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

void main(int argc, char *argv[]){
    unsigned char *b;
    FILE *fid;
    float num,begin;
    float times[1000];// time must be less than 1000 epoch
    const int32_t bdipsize=196;
    int32_t n, count=0,file_size,nbdip,i,nn=0;
    // read time.txt
    fid = fopen(argv[2],"r");
    if (fid == NULL){
        printf("unable to open TIME-file\n");
        return;
    }
    while(fscanf(fid,"%f",&num) == 1){
        times[count] = num;
        count = count+1;
    }
    fclose(fid);
    // read BDIP file as byte-stream
    fid = fopen(argv[1],"rb");
    if (fid == NULL){
        printf("unable to open BDIP-file\n");
        return;
    }
    fseek(fid,0,SEEK_END);
    file_size = ftell(fid);
    fseek(fid,0,SEEK_SET);
    if (file_size == 0){
        printf("file size is zero!\n");
        fclose(fid);
        return;
    }
    if (file_size % bdipsize > 0){
        printf("This is not BDIP file\n");
        fclose(fid);
        return;
    }
    nbdip = file_size / bdipsize;
    b=(unsigned char*)malloc(file_size);
    if (b == NULL){
        printf("unable to allocate memory\n");
        fclose(fid);
        return;
    }
    fread(b,sizeof(unsigned char),file_size,fid);
    fclose(fid);
    
    // overwrite BDIP
    fid=fopen(argv[1],"wb");
    for(i=0;i<nbdip;i++){
        getfloat(&b[4+i*bdipsize],&begin);
        begin = begin*1000;
        for (n=0;n<count;n++){
      	    if (begin == times[n]){
                fwrite(&b[i*bdipsize],bdipsize,1,fid);
                nn=nn+1;
            }
        }
    }
    fclose(fid);
    free(b);
    printf("%d dipoles are extracted\n",nn);
    return;
}
