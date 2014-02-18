git pull origin product
ps aux|grep blog|awk '{print $2}'|xargs kill -9
make all
nohup ./blog &
