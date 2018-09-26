all: minibank network mariadb run

bin/minibank: $(shell find $(SRCDIR) -name '*.go')
	docker run -it -v `pwd`:/usr/app \
	-w /usr/app \
	-e GOPATH=/usr/app \
	-e CGO_ENABLED=0 \
	-e GOOS=linux \
	golang:1.9 sh -c 'go get minibank && go build -ldflags "-extldflags -static" -o $@ minibank'

network:
	docker network create network

minibank: bin/minibank
	docker build -t minibank .

mariadb:
	docker build -t mariadb ./mariadb/ 

run: minibank mariadb
	docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=hobbes -v `pwd`/mariadb:/docker-entrypoint-initdb.d:ro --net network --link minibank mariadb
	docker run  -d  --name minibank   --net network minibank


