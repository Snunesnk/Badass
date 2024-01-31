sudo docker build -t frrouting ./frrouter-image .
sudo docker build -t alpine ./alpine-image .

sudo docker run --privileged -d ffrouting
sudo docker run --privileged -d alpine

# Check with "ps" on auxiliary console that bgpd, ospfd and isisd are running