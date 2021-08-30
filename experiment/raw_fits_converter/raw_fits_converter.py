import sys
import astropy.io.fits as fits
import numpy as np
import numba as nb
import math

#numbaを使うと処理が高速化されるらしい。使わない場合は下の@の行をコメントアウト
#@nb.njit(nb.uint16[::1](nb.uint8[::1]),fastmath=True,parallel=False)
@nb.njit(fastmath=True,parallel=False)

def nb_read_uint12(data_chunk):
  """data_chunk is a contigous 1D array of uint8 data)
  eg.data_chunk = np.frombuffer(data_chunk, dtype=np.uint8)"""

  #バイナリを12bitごとに切り出して配列に入れる
  #パクリ元 : https://stackoverflow.com/questions/44735756/python-reading-12-bit-binary-files
  #5byteに3ピクセル×12bitのデータが入ってるので、8bit(= 1byte)ごとに分割して12bitのデータ×3に直す
  #詳細はFPGA要求仕様書の"FPGA ⇒ PC 方向フレームモードパケット"の項を見るべし
  #バイナリの下位bitの取り出し方 : 取り出したい桁を1、いらない桁を0としたバイナリと&をとればよい
  #バイナリの上位bitの取り出し方 : 必要な桁までbitを右シフト(>>)させればよい
  
  #ensure that the data_chunk has the right length
  assert np.mod(data_chunk.shape[0],5)==0
  #print(data_chunk.shape)
  
  out=np.empty(data_chunk.shape[0]//5*3,dtype=np.uint16)
  
  for i in nb.prange(data_chunk.shape[0]//5):
    uint8_1=np.uint16(data_chunk[i*5])
    uint8_2=np.uint16(data_chunk[i*5+1])
    uint8_3=np.uint16(data_chunk[i*5+2])
    uint8_4=np.uint16(data_chunk[i*5+3])
    uint8_5=np.uint16(data_chunk[i*5+4])
    
    out[i*3] =   ((uint8_1&0b00111111) << 6) + (uint8_2 >> 2)
    out[i*3+1] = ((uint8_2&0b00000011) << 10) + (uint8_3 << 2) + (uint8_4 >> 6)
    out[i*3+2] = ((uint8_4&0b00111111) << 6) + (uint8_5 >>2)

  return out


def converter():
  img_width = int(sys.argv[1])
  img_height = int(sys.argv[2])

  i = 3
  while i<=len(sys.argv)-1 :

    print("Image dimensions = " + str(img_width) + " × " + str(img_height))
    print("Bit depth = 12bit (4096)")

    rawname = sys.argv[i]
    filename = rawname.split('.')
    fitsname = filename[0]+'.fits'

    #画像データの総byteを計算
    #2048×2048では6990510
    img_size = img_width*img_height
    img_byte = math.ceil(img_size/3)*5
    print("Input image size = " + str(img_byte) + " byte(s) without header/footer")

    #ヘッダーを飛ばして画像データの容量のbyte数だけバイナリモードで読み込む
    file = open(rawname, 'rb')
    file.seek(20)
    rawdata = file.read(img_byte)
    file.close()

    #読み込んだバイナリデータを1byte(= 8bit)ごとに分割して1次元配列にする
    data_chunk = np.frombuffer(rawdata, dtype=np.uint8)
    #print(data_chunk)

    #分割したバイナリを12bitの1次元配列に変換
    #3ピクセルで1つの塊なので総ピクセル数が3の倍数のとき以外では終わりにパディングのピクセルが入っていることに注意
    img = nb_read_uint12(data_chunk)
    #print(img)

    #12bitごとの1次元配列をピクセルの配列と同じサイズに変形
    #パディングで出てきたピクセルは無視される
    #width = 2048
    #height = 2048
    img_out = np.flipud(np.resize(img,(img_width,img_height)))
    print("Output image name = " + fitsname)
    print("Output image value = ")
    print(img_out)
    print()

    #画像データの配列をfitsファイルにして書き出し
    #header = fits.header()
    hdu = fits.PrimaryHDU(img_out)
    #hdu.header['rawname'] = rawname
    #hdulist = fits.HDUList([hdu])
    hdu.writeto(fitsname,overwrite=True)

    i+=1


if __name__ == '__main__':

  args = sys.argv

  if args[1].isdigit() and args[2].isdigit():
    converter()

  else:
    print("useage : raw_fits_converter.py [width(pixel)] [height(pixel)] [infile1] ([infile2]...)!")



