#! /bin/bash
#bashの変数展開によるファイル名や拡張子の取得というサイト参考
#シェルスクリプトで複数ファイルを一括リネームする方法というサイト参考

#if [ $# -lt 4 ]
#then
#    echo "X-ray file, dark file, file name, -"
#    exit 1
#fi

#args=$*
#extra_args="$2"
#files=${args#$extra_args}


if [ $# -lt 2 ]
then
echo "ダークファイル　データファイル　と入力してください"
exit 1
fi
#引数が２個ないとエラーを出力してくれる。２個あればOK

args=$*
extra_args="$1"
files=${args#$extra_args}
#２つの引数から、ループを回すデータファイルの方だけを抽出して変数に格納している


for f in $files
do
    var="${f%.*}"
#    echo $var
    farith $f $1 "$var"_ds.fits -
done
#varに拡張子なしのファイル名だけを格納して、ダーク引きした後、ファイル名_ds.fitsに名前を変更して保存


#args=$*
#extra_args="$1 $2"
#files=${args#$extra_args}

#for f in $files
#for f in *
#do
#    var="${f%.*}"
#    echo $var
#    farith $f $2 $var_ds.fits -
#done


#for file_name in `ls ds_*.fits`
#do
#   var="${file_name%.*}"
#   echo $var
#   mv $file_name ${file_name/ds_$var/$var_ds/}
#done


#for file_name in `ls *.fits`
#do
#farith "$file_name" "5s_d.fits" "ds_$file_name" -
#done




#args=$*
#extra_args="$1 $2"
#files=${args#$extra_args}

#for f in $files
#do
#	mv $f ${f/$1/$2}
#done
