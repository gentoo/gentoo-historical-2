DESTDIR = /usr/share/sgml/docbook/sgml/dtd/4.1

all: install

install:
	mkdir -p $(DESTDIR)
	install *.dcl $(DESTDIR)
	install docbook.cat $(DESTDIR)/catalog
	install *.dtd $(DESTDIR)
	install *.mod $(DESTDIR)
