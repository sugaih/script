/* Event subtraction program
 * copy from event_subtract Ver 2.1 21 July 2000 made by Masahiro Kawasaki
 * Time-stamp: <08/03/17 11:30:25 xrt> 
 * Created by Hiroshi Murakami
 * Ver. 1.0;  modified to ignore header part
 *             and read binary data
 * Ver. 1.1;  modified to output position
 *           & applicable to plural files
 * Ver  2.0   adjust for the fits inputs Y. Maeda
 *
 * Ver  2.1   correct grade6 events    
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fitsio.h>

int main(int argc,char **argv)
{
  fitsfile *imgunit;  // ymaeda
  int i, j, k,x,y;
  double p, p0, p1, p2, p3, p4, p5, p6, p7, p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24;
  double event,split,upper;  
  double *table;
  int status = 0;
  char *comment;
  int n;
  //  char fname[256],opfile[256],head[80];
  
  comment    = malloc(1024);
  
  //  FILE  *fp, *fd ;

  
  if(argc<5){
    printf("usage: event_extract_wh file1 [file2] ... \n");
    exit(1);
  } else {
    
    //    fprintf(stderr,"%s\n",argv[1]);
    event = atof(argv[1]);
    //    fprintf(stderr,"%e\n",event);
    split = atof(argv[2]);
    //    fprintf(stderr,"%e\n",split);
    upper = atof(argv[3]);
    //    fprintf(stderr,"%e\n",upper);
    /*    
    fprintf(stderr,"Enter the region of notice(x y) >>");
    scanf("%d %d",&x,&y);
    fprintf(stderr,"Enter Event threshold value =>");
    scanf("%d",event);
    fprintf(stderr,"Enter Split threshold value =>");
    scanf("%d",split);
    fprintf(stderr,"Enter UpperLimit value =>");
    scanf("%d",upper);
    */
  }
  
  for(k=4;k<argc;k++){
    //    fprintf(stderr,"1\n");
    ffopen( &imgunit, argv[k], READONLY, &status);
    fprintf(stderr,"Input frame data is %s.\n",argv[k]);
    //    fprintf(stderr,"2\n");
    ffgky( imgunit, TINT, "NAXIS1", &x, comment, &status); 
    fprintf(stderr,"Fits image is %i x ", x);
    ffgky( imgunit, TINT, "NAXIS2", &y, comment, &status); 
    fprintf(stderr,"%i\n", y);
    
    /* メモリ割り当て */
    table = (double *)calloc(x*y,sizeof(double));
    if(table == NULL){
      fprintf(stderr,"Can't allocate memory.\n");
      exit(1);
    }
    
    ffgpvd(imgunit, 1, 1, x*y, 0, table, &n, &status); 
    
 
  for(i=2;i< y-2;i++){
    for(j=2;j< x-2;j++){
      
      p0 = *(table+i*x+j);
      p1 = *(table+(i-1)*x+(j-1));
      p2 = *(table+(i-1)*x+j);          /*      Pixel Format      */  
      p3 = *(table+(i-1)*x+(j+1));      /*                        */
      p4 = *(table+i*x+(j-1));          /*  p9  p10 p11 p12 p13   */
      p5 = *(table+i*x+(j+1));          /*  p14 p1  p2  p3  p15   */
      p6 = *(table+(i+1)*x+(j-1));      /*  p16 p4  p0  p5  p17   */
      p7 = *(table+(i+1)*x+j);          /*  p18 p6  p7  p8  p19   */
      p8 = *(table+(i+1)*x+(j+1));      /*  p20 p21 p22 p23 p24   */
      
      p9 = *(table+(i-2)*x+(j-2));
      p10 = *(table+(i-2)*x+(j-1));
      p11 = *(table+(i-2)*x+j);
      p12 = *(table+(i-2)*x+(j+1));
      p13 = *(table+(i-2)*x+(j+2));
      p14 = *(table+(i-1)*x+(j-2));
      p15 = *(table+(i-1)*x+(j+2));
      p16 = *(table+i*x+(j-2));
      p17 = *(table+i*x+(j+2));
      p18 = *(table+(i+1)*x+(j-2));
      p19 = *(table+(i+1)*x+(j+2));
      p20 = *(table+(i+2)*x+(j-2));
      p21 = *(table+(i+2)*x+(j-1));
      p22 = *(table+(i+2)*x+j);
      p23 = *(table+(i+2)*x+(j+1));
      p24 = *(table+(i+2)*x+(j+2));
      
      /* Grade0; Perfect Single */
      
      if( p0 >= event && p0 <= upper
	  && p1 < split && p2 < split && p3 < split && p4 < split
	  && p5 < split && p6 < split && p7 < split && p8 < split
	  && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	  && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	  && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	  && p24 < p0
	  ){
	printf("0 %4.2f",p0);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade1; S + Detouched Corners */
      
      else if( p0 >= event && p0 <= upper
	       && p1 < p0 && p3 < p0 && p6 < p0 && p8 < p0
	       && p2 < split && p4 < split  && p5 < split && p7 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	printf("1 %4.2f",p0);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade2; Vertical Single-Sided Split + Detouched Corners */
      
      else if( p0 >= event && p0 <= upper && split < p2 && p2 < p0 
	       && p6 < p0 && p8 < p0
	       && p1 < split && p3 < split && p4 < split && p5 < split 
	       && p7 < split  
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p2 ;
	printf("2 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p7 && p7 < p0 
	       && p1 < p0 && p3 < p0
	       && p2 < split && p4 < split 
	       && p5 < split && p6 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p7 ;
	printf("2 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      } 
      
      /* Grade3; Left Single-Sided Split + Detouched Corners */
      
      else if( p0 >= event && p0 <= upper && split < p4 && p4 < p0 
	       && p3 < p0 && p8 < p0
	       && p1 < split && p2 < split && p5 < split 
	       && p6 < split && p7 < split 
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p4 ;
	printf("3 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade4; Right Single-Sided Split + Detouched Corners */
      
      else if( p0 >= event && p0 <= upper && split < p5 && p5 < p0 
	       && p1 < p0 && p6 < p0
	       && p2 < split && p3 < split && p4 < split 
	       && p7 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p5 ;
	printf("4 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade5; Single-Sided Split with Touched Corners */
      
      else if( p0 >= event && p0 <= upper && split < p2 && p2 < p0
	       && p1 < p0 && p3 < p0 && p6 < p0 && p8 < p0 
	       && p4 < split && p5 < split  && p7 < split 
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p2;
	printf("5 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p4 && p4 < p0 
	       && p1 < p0 && p6 < p0 && p3 < p0 && p8 < p0
	       && p2 < split && p5 < split && p7 < split 
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p4 ;
	printf("5 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p5 && p5 < p0 
	       && p1 < p0 && p3 < p0 && p6 < p0 && p8 < p0
	       && p2 < split && p4 < split && p7 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p5 ;
	printf("5 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p7 && p7 < p0
	       && p1 < p0 && p3 < p0 && p6 < p0 && p8 < p0 
	       && p2 < split && p4 < split && p5 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p7 ;
	printf("5 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade6; L Shape and Square Shape + Detouched Corners */
      
      else if( p0 >= event && p0 <= upper && p1 < split
	       && split < p2 && p2 < p0 && split < p4 && p4 < p0 
	       && p8 < p0
	       && p3 < split && p5 < split && p6 < split && p7 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p2 + p4 ;
	//printf("6.1 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p1 && p1 < p0
	       && split < p2 && p2 < p0 && split < p4 && p4 < p0 
	       && p8 < p0
	       && p3 < split && p5 < split && p6 < split && p7 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p1 + p2 + p4 ;
	//printf("6.2 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && p3 < split
	       && split < p2 && p2 < p0 && split < p5 && p5 < p0 
	       && p6 < p0
	       && p1 < split && p4 < split && p7 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p2 + p5 ;
	//printf("6.1 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p3 && p3 < p0
	       && split < p2 && p2 < p0 && split < p5 && p5 < p0 
	       && p6 < p0
	       && p1 < split && p4 < split && p7 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p2 + p3 + p5 ;
	//printf("6.2 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && p6 < split
	       && split < p4 && p4 < p0 && split < p7 && p7 < p0 
	       && p3 < p0
	       && p1 < split && p2 < split && p5 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p4 + p7 ;
	//printf("6.1 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p6 && p6 < p0
	       && split < p4 && p4 < p0 && split < p7 && p7 < p0 
	       && p3 < p0
	       && p1 < split && p2 < split && p5 < split && p8 < split
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p4 + p6 + p7 ;
	//printf("6.2 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && p8 < split
	       && split < p5 && p5 < p0 && split < p7 && p7 < p0 
	       && p1 < p0
	       && p2 < split && p3 < split && p4 < split && p6 < split 
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p5 + p7 ;
	//printf("6.1 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      else if( p0 >= event && p0 <= upper && split < p8 && p8 < p0
	       && split < p5 && p5 < p0 && split < p7 && p7 < p0 
	       && p1 < p0
	       && p2 < split && p3 < split && p4 < split && p6 < split 
	       && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	       && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	       && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	       && p24 < p0
	       ){
	p = p0 + p5 + p7 + p8 ;
	//printf("6.2 %4.2f",p);
	printf("6 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      }
      
      /* Grade7; Spread more than 2x2 pixel */
      
      else if(p0 >= event && p0 <= upper
	      && p1 < p0 && p2 < p0 && p3 < p0 && p4 < p0 && p5 < p0
	      && p6 < p0 && p7 < p0 && p8 < p0
	      && p9 < p0 && p10 < p0 && p11 < p0 && p12 < p0 && p13 < p0 
	      && p14 < p0 && p15 < p0 && p16 < p0 && p17 < p0 && p18 < p0
	      && p19 < p0 && p20 < p0 && p21 < p0 && p22 < p0 && p23 < p0
	      && p24 < p0
	      ){
	p = p0+p1+p2+p3+p4+p5+p6+p7+p8+p9+p10+p11+p12+p13+p14+p15+p16+p17+p18+p19+p20+p21+p22+p23+p24;
	printf("7 %4.2f",p);
	printf(" %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %d %d\n",p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,j+1,i+1);
      } else {
      }
    }
  }
    
    free(table);
    fprintf(stderr,"successful!\n");
    
  }

    ffclos(imgunit, &status);
    return(0);

}  
