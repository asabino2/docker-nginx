FROM ubuntu
ENV TZ=America/Sao_Paulo
WORKDIR /
#VOLUME ["/usr/local/nginx/conf/nginx.conf"]
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
#RUN apt install -y nginx
RUN apt install -y build-essential git
RUN apt install -y libpcre3-dev libssl-dev zlib1g-dev
#RUN apt install -y git
#RUN apt install -y curl
RUN mkdir ./build-nginx
WORKDIR /build-nginx
RUN git clone https://github.com/arut/nginx-rtmp-module.git
RUN git clone https://github.com/nginx/nginx.git
WORKDIR /build-nginx/nginx
RUN ./auto/configure --add-module=../nginx-rtmp-module
RUN make
RUN make install
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./startnginx.sh /
RUN chmod +x /startnginx.sh
EXPOSE 1935/tcp
EXPOSE 80/tcp   
EXPOSE 9000/tcp
LABEL description="imagem para realização de transmissões via streaming"
RUN rm -r /build-nginx
RUN apt remove -y git
WORKDIR /

#ENTRYPOINT ["/startnginx.sh"]
CMD /startnginx.sh ; sleep infinity            
