/* Separate image fits file program 
 * Time-stamp: <12/06/19 12:34 xrt> 
 * Created by Takayuki Hayashi
 * Time-stamp: <12/06/19 12:34 xrt> 
 * Created by Takayuki Hayashi
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fitsio.h>

int main(int argc,char **argv)
{
  fitsfile *imgunit,*outimg;
  FILE *prox_out,*proy_out;
  int i,j,k,x,y,bit,pos;
  int xmin, xmax, ymin, ymax, axis=2;
  long axes[2],fpixel=1,nelement;
  double p,*table,*new_table,*prox,*proy;
  int status = 0;
  char *comment,outimg_part[200],outimg_name[200],prox_name[250],proy_name[250];
  int n;
  //  char fname[256],opfile[256],head[80];
  
  comment    = malloc(1024);
  
  //  FILE  *fp, *fd ;

    if(argc<6){
    printf("usage: extract_part xmin xmax ymin ymax file1 [file2] ... \n");
    printf("Image region : extract_part 1 1240 1 1152 file1 [file2] ... \n");
    printf("All region : extract_part 1 1744 1 1648 file1 [file2] ... \n");
    exit(1);
  } else {
    
    /*xmin = atof(argv[1]);
    xmax = atof(argv[2]);
    ymin = atof(argv[3]);
    ymax = atof(argv[4]);*/

    xmin = atoi(argv[1]);
    xmax = atoi(argv[2]);
    ymin = atoi(argv[3]);
    ymax = atoi(argv[4]);

    xmin--;
    xmax--;
    ymin--;
    ymax--;


    /*fprintf(stderr,"%d ",xmin);
    fprintf(stderr,"%d ",xmax);
    fprintf(stderr,"%d ",ymin);
    fprintf(stderr,"%d\n",ymax);*/
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

    if(xmin>xmax || ymin>ymax){
      fprintf(stderr,"Check entered number.\n");
      exit(1);
    }
  
  for(k=5;k<argc;k++){
    
    strcpy(outimg_part,argv[k]);
    strtok(outimg_part,".");

    /*fprintf(stderr,"%s_x%d-%d_y%d-%d.fits\n",outimg_part,xmin,xmax,ymin,ymax);*/
    sprintf(outimg_name,"%s_x%d-%d_y%d-%d.fits",outimg_part,xmin+1,xmax+1,ymin+1,ymax+1);

    sprintf(prox_name,"%s_x%d-%d_y%d-%d_prox.dat",outimg_part,xmin+1,xmax+1,ymin+1,ymax+1);
    sprintf(proy_name,"%s_x%d-%d_y%d-%d_proy.dat",outimg_part,xmin+1,xmax+1,ymin+1,ymax+1);

    remove(outimg_name);
    remove(prox_name);
    remove(proy_name);

    //    fprintf(stderr,"1\n");
    ffopen( &imgunit, argv[k], READONLY, &status);    
    //fits_open_file( &imgunit, argv[k], READONLY, &status);    
    fprintf(stderr,"Input frame data is %s.\n",argv[k]);
    //    fprintf(stderr,"2\n");
    fits_read_key( imgunit, TINT, "NAXIS1", &x, comment, &status); 
    fprintf(stderr,"Fits image is %i x ", x);
    fits_read_key( imgunit, TINT, "NAXIS2", &y, comment, &status); 
    fprintf(stderr,"%i\n", y);
    fits_read_key( imgunit, TINT, "BITPIX", &bit, comment, &status); 
    /*fprintf(stderr,"%i\n", bit);*/

    if(xmax>x || ymax>y){
      fprintf(stderr,"Enterd maximum value over pixel number.\n");
      exit(1);
    }

    /* メモリ割り当て */
    table = (double *)calloc(x*y,sizeof(double));
    if(table == NULL){
      fprintf(stderr,"Can't allocate memory.\n");
      exit(1);
    }

    fits_read_img_dbl(imgunit, 1, 1, x*y, 0, table, &n, &status); 

    axes[0] = xmax-xmin+1;
    axes[1] = ymax-ymin+1;

    nelement = axes[0]*axes[1];
    fprintf(stderr,"Output image is %ld x %ld\n",axes[0],axes[1]);

    /*fpixel = xmin;*/
    
    new_table = (double *)calloc(axes[0]*axes[1],sizeof(double));
    if(table == NULL){
      fprintf(stderr,"Can't allocate memory.\n");
      exit(1);
    }       

    proy = (double *)calloc(axes[1],sizeof(double));
    if(table == NULL){
      fprintf(stderr,"Can't allocate memory.\n");
      exit(1);
    }       

    prox = (double *)calloc(axes[0],sizeof(double));
    if(table == NULL){
      fprintf(stderr,"Can't allocate memory.\n");
      exit(1);
    }       

    fprintf(stderr,"Output file is %ld x %ld, %s.\n",axes[0],axes[1],outimg_name);

    pos = 0;

    for(j=0;j<=y;j++){

      for(i=0;i<=x;i++){     

	  if(j>=ymin && j<=ymax){

	    if(i>=xmin && i<=xmax){

	    p = *(table+j*x+i);

	    new_table[pos]=p;
	    pos++;
	      
	    prox[i-xmin] = prox[i-xmin] + p;
	    proy[j-ymin] = proy[j-ymin] + p;

	    /*printf("0 %4.2f %d %d\n",p,i+1,j+1);*/
	    /*printf("%e %e\n",prox[i-ymin],proy[j-]);*/

	  }

	}

      }

    }


    free(table);

    ffclos(imgunit, &status);

    fits_create_file(&outimg,outimg_name,&status);
    fits_create_img(outimg,bit,axis,axes,&status);
    /*fits_write_img(outimg,TDOUBLE,fpixel,nelement,new_table,&status);*/
    fits_write_img(outimg,TDOUBLE,fpixel,nelement,new_table,&status);
    ffclos(outimg,&status);

    prox_out = fopen(prox_name,"w");

      fprintf(prox_out,"fo ro\n");
      fprintf(prox_out,"lw 4\n");
      fprintf(prox_out,"cs 1.3\n");
      fprintf(prox_out,"col 1 on 2\n");
      fprintf(prox_out,"la x Det-X (pixel)\n");
      fprintf(prox_out,"la y ADU\n");
      fprintf(prox_out,"!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    for(i=1;i<=axes[0];i++){
      fprintf(prox_out,"%d %.5e\n",i,prox[i-1]);
    }
    fclose(prox_out);

    proy_out = fopen(proy_name,"w");

      fprintf(proy_out,"fo ro\n");
      fprintf(proy_out,"lw 4\n");
      fprintf(proy_out,"cs 1.3\n");
      fprintf(proy_out,"col 1 on 2\n");
      fprintf(proy_out,"la x Det-Y (pixel)\n");
      fprintf(proy_out,"la y ADU\n");
      fprintf(proy_out,"!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

    for(j=1;j<=axes[1];j++){
      fprintf(proy_out,"%d %.5e\n",j,proy[j-1]);
    }
    fclose(proy_out);

    fprintf(stderr,"successful!\n");

    free(new_table);



  }

    return(0);

}  

