# This file will zip up all files in the current directory into a proper .love file.
# Use the argument "clean" to remove the .love file.

all: polaroidal

polaroidal:
	zip -9 -q -r polaroidal.love .

clean:
	rm *.love
