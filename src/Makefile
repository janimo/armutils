
CC=gcc
LD = ld

LINKS = rmdir swapoff

OBJECTS =  acid cat head httpd kill ln mkdir ping sync swapon tail 

all:	$(OBJECTS) links

%	:%.S

	$(CC) -nostdlib -Wl,--oformat,binary  -I../include $< -o $@ 
	../tools/trunc $@
	
clean:
	rm -f $(OBJECTS)
	rm $(LINKS)	
trunc:
	../tools/trunc $(OBJECTS)
links:
	ln -s mkdir rmdir
	ln -s swapon swapoff
