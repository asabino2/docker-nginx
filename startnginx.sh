#!/bin/sh
echo "starting nginx..."

echo ""
/usr/local/nginx/sbin/nginx
#echo "realizando teste de conectividade"
echo "checking nginx.conf file"
/usr/local/nginx/sbin/nginx -t
#echo "teste 2 -> teste de conectividade"
#curl 127.0.0.1
echo ""
echo ""
echo ""
echo ""
echo "****************************************************************************************"
echo "if test is ok, the use the following urls:"
echo "rtmp://${HOSTNAME}:1935/feed/<chave>, broadcast without HLS"
echo "rtmp://${HOSTNAME}:1935/hls/<chave>, broadcast with HLS"
echo "http://${HOSTNAME}:9000/hls/<chave>.m3u8 url with HLS streaming for play"
echo "****************************************************************************************"
##echo "pressione qualquer tecla para sair"
#read dummy
#bash
