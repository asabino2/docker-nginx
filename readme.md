![](https://www.aktifperunding.com/upload/content/23/20190115154203_1.jpg)

NGNIX server with RTMP for use in livestream\
\

  ------------------------------------ -----------------------------------------------------
  Url                                  Description
  rtmp://localhost:1935/feed/\<key\>   Livestream address withou HLS
  rtmp://localhost:1935/hls/\<key\>    Livestream address with HLS
  http://localhost:9000/hls.m3u8       Url of HLS stream (for use in website, for exemple)
  ------------------------------------ -----------------------------------------------------

\
You can copy the nginx file below to a new file and map the file for
yours, example

you copy the file below to /home/nginx.conf and modify this, then to use
her, run the container with:

 

`docker run -d -p:1935:1935 -p 9000:9000 -p:80:80 -v /home/nginx.conf:/usr/local/nginx/conf/nginx.conf asabino2/rtmpserver`

file nginx.conf

    #user  nobody;

    worker_processes  1;



    error_log  logs/rtmp_error.log debug;

    pid        logs/nginx.pid;



    events {

        worker_connections  1024;

    }



    http {

        server {

            listen       9000;

            server_name  localhost;



            location /hls {

                # Serve HLS fragments



                # CORS setup

                add_header 'Access-Control-Allow-Origin' '*' always;

                add_header 'Access-Control-Expose-Headers' 'Content-Length';



                # allow CORS preflight requests

                if ($request_method = 'OPTIONS') {

                    add_header 'Access-Control-Allow-Origin' '*';

                    add_header 'Access-Control-Max-Age' 1728000;

                    add_header 'Content-Type' 'text/plain charset=UTF-8';

                    add_header 'Content-Length' 0;

                    return 204;

                }





                types {

                    application/vnd.apple.mpegurl m3u8;

                    video/mp2t ts;

                }

                root /tmp;

                add_header Cache-Control no-cache;

            }

        }

    }



    rtmp {

            server {

                    listen 1935;

                    chunk_size 8192;



                    application hls {

                            live on;

                            meta copy;

                         #   push rtmp://a.rtmp.youtube.com/live2/;

                            hls on;

                            hls_path /tmp/hls;

            }
            
                 application feed {

                            live on;

                            meta copy;

                         #   push rtmp://a.rtmp.youtube.com/live2/;

                            #hls on;

                            #hls_path /tmp/hls;

            }

        }

    }

