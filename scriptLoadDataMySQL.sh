DIR=/Users/reno/spark/data_5GB
ls $DIR/*.dat | while read file; do
    pipe=$file.pipe
    mkfifo $pipe
    table=`basename $file .dat | sed -e 's/_[0-9]_[0-9]//'`
    echo $file $table
    LANG=C && sed -e 's_^|_\\N|_g' -e 's_||_|\\N|_g' -e 's_||_|\\N|_g' $file > $pipe & \
    mysql tpcds5gb -utpcds -pTPCds2018 --local-infile -Dtpcds -e \
          "load data local infile '$pipe' replace into table $table character set latin1 fields terminated by '|'"
    rm -f $pipe
done