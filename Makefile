# Go parameters
GOCMD=go
ENTRYFILE=cmd/skipper/main.go
GOBUILD=$(GOCMD) build $(ENTRYFILE)
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=skipper
BINARY_UNIX=$(BINARY_NAME)

all: libinjection compile
compile: 	
		CGO_ENABLED=1 go get ./...
		$(GOBUILD)
test: 
		$(GOTEST) ./...
		$(GOTEST) -v -coverprofile=docs/coverage-waf.out ./...
clean: 
		$(GOCLEAN)
		rm -f $(BINARY_NAME)
libinjection:
		gcc -std=c99 -Wall -Werror -fpic -c pkg/utils/libinjection/src/libinjection_sqli.c -o libinjection_sqli.o 
		gcc -std=c99 -Wall -Werror -fpic -c pkg/utils/libinjection/src/libinjection_xss.c -o libinjection_xss.o
		gcc -std=c99 -Wall -Werror -fpic -c pkg/utils/libinjection/src/libinjection_html5.c -o libinjection_html5.o
		gcc -dynamiclib -shared -o libinjection.so libinjection_sqli.o libinjection_xss.o libinjection_html5.o
		#OS X: update_dyld_shared_cache
		cp *.so /usr/local/lib
		cp *.o /usr/local/lib
		cp pkg/utils/libinjection/src/*.h /usr/local/include/
		chmod 444 /usr/local/include/libinjection*
		ldconfig				
deps-debian:
		apt install libpcre++-dev build-essential