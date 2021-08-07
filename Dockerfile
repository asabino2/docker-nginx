FROM ubuntu
#Especifica o fuso horário para SP
ENV TZ=America/Sao_Paulo  
WORKDIR /
#Força o fuso horário no sistema
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# realiza o update do repositório do ubuntu
RUN apt update
# Instala o GIT
RUN apt install -y build-essential git
# instala algumas bibliotecas
RUN apt install -y libpcre3-dev libssl-dev zlib1g-dev
# Cria o diretório para build do rtmp
RUN mkdir ./build-nginx
WORKDIR /build-nginx
# baixa o nginx e o modulo rtmp
RUN git clone https://github.com/arut/nginx-rtmp-module.git
RUN git clone https://github.com/nginx/nginx.git
WORKDIR /build-nginx/nginx
# compila o modulo nginx
RUN ./auto/configure --add-module=../nginx-rtmp-module
RUN make
RUN make install
# faz uma cópia do arquivo nginx de configuração de exemplo
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
# copia o script de start do nginx
COPY ./startnginx.sh /
RUN chmod +x /startnginx.sh
# expondo as portas 80 (para teste de conectividade), 9000 (HTTP HLS) e 1935 (RTMP)
EXPOSE 1935/tcp
EXPOSE 80/tcp   
EXPOSE 9000/tcp
LABEL description="imagem para realização de transmissões via streaming"
# remove o diretório de compilação do module rtmp, pois não vai precisar mais
RUN rm -r /build-nginx
# remove o GIT
RUN apt remove -y git
WORKDIR /

# inicia o nginx e mantem o sistema travado para que o docker não pare o container
CMD /startnginx.sh ; sleep infinity            
