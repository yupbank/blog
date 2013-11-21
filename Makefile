
all:exe

racolink:
	raco link externals/markdown/markdown/
	raco link externals/rackjure/rackjure/
	raco link externals/parsack/parsack/

exe:
	raco exe blog.rkt

clean:
	rm -f blog
