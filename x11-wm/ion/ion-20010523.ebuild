# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Damon Conway <kabau@gentoo.org>
# /home/cvsroot/gentoo-x86/skel.build,v 1.8 2001/10/11 17:50:47 woodchip Exp

S=${WORKDIR}/${P}
DESCRIPTION="A keyboard-based window manager"
SRC_URI="http://www.students.tut.fi/~tuomov/dl/ion-20010523.tar.gz"
HOMEPAGE="http://www.students.tut.fi/~tuomov/ion/"
DEPEND="virtual/glibc"
RDEPEND="virtual/x11"

src_compile() {
	cd ${S}

	# Edit system.mk
	sed -e 's:PREFIX=/usr/local:PREFIX=/usr:' \
		-e 's:ETCDIR=$(PREFIX):ETCDIR=:' \
		-e 's:$(PREFIX)/man:$(PREFIX)/share/man:' \
		-e 's:$(PREFIX)/doc:$(PREFIX)/share/doc:' \
		-e 's:#HAS_SYSTEM_ASPRINTF=1:HAS_SYSTEM_ASPRINTF=1:' \
		-e 's:#INSTALL=install -c:INSTALL=install -c:' \
		-e 's:INSTALL=install *$:#INSTALL=install:' \
		system.mk > system.mk.new
	mv system.mk.new system.mk

	# Edit Makefile
	# I don't know how to use ${P} instead of typing the whole version
	# here. At some point, it should be cleaned up.
	sed -e 's:$(DOCDIR)/ion:$(DOCDIR)/ion-20010523:g' Makefile > Makefile.new
	mv Makefile.new Makefile

	make depend || die
	emake || die
}

src_install () {
	make PREFIX=${D}/usr ETCDIR=${D}/etc install || die
}

pkg_postinst () {
	einfo "Configuration documentation can be found in these places:"
	einfo "/usr/share/doc/${P}/config.txt"
	einfo "http://www.students.tut.fi/~tuomov/ion/resources.html"
}
