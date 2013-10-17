
all:exe

racolink:
	raco link externals/markdown/markdown/
	raco link externals/rackjure/rackjure/

exe:
	raco exe blog.rkt

clean:
	rm -f blog
