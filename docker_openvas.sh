docker volume create openvas
docker run -d -p 443:443 -p 9390:9390 -v openvas:/var/lib/openvas/mgr -e OV_UPDATE=yes --name openvas atomicorp/openvas
#docker exec -it openvas bash
## inside container
#greenbone-nvt-sync
#openvasmd --rebuild --progress
#greenbone-certdata-sync
#greenbone-scapdata-sync
#openvasmd --update --verbose --progress
#/etc/init.d/openvas-manager restart
#/etc/init.d/openvas-scanner restart
