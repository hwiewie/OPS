#DockerFile 開頭必須是 FROM 指定一個底層映像檔
FROM centos:centos7.8.2003
#映像檔維護者, 可以當成作者
MAINTAINER Hugo
#LABEL 設定映像檔的 Metadata
LABEL description="fish server" version="1.0" owner="i8"
#RUN - Build 時的指令，必須使用 雙引號 的格式框住指令，使用 && 串聯 多個 RUN 指令
#CMD - 執行 Container 時的指令，只有最後一行 CMD 指令會生效
#ENTRYPOINT - 執行 Container 時的指令，只有最後一行 CMD 指令會生效
#ADD 和 COPY - 增加與複製檔案，ADD 支援 URL 路徑，ADD 會自動解壓縮
#EXPOSE - 監聽 port，須使用 -p 或 -P 參數啟用
#ENV - 環境指令 ENV <key>=<value>，在container建立後也可使用
#ARG - 在建置映像檔時可傳入的參數，無法在運行 Container 時執行
#VOLUME - 掛載目錄指令
#WORKDIR - 設定工作目錄指令
#USER - 運行 Container 時的使用者名稱或ID
#ONBUILD - 在被別人當作 底層映像檔時，執行完 FROM 之後會優先執行你寫入的 ONBUILD 指令，後續才是他人寫的指令
