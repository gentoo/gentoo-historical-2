# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/analog/analog-5.1.ebuild,v 1.1 2002/01/02 03:19:38 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The most popular logfile analyser in the world"
HOMEPAGE="http://www.analog.cx/"
SRC_URI="http://www.analog.cx/${P}.tar.gz"
DEPEND="virtual/glibc >=dev-libs/libpcre-3.4 >=media-libs/libgd-1.8.3 >=sys-libs/zlib-1.1.3"

src_unpack() {
	unpack ${A} ; cd ${S}
	mv src/Makefile src/Makefile.orig
	sed -e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" \
		-e 's:^DEFS.*:DEFS = -DHAVE_GD -DHAVE_PCRE:' \
		-e 's:^LIBS.*:LIBS = -lgd -lpng -ljpeg -lz -lpcre -lm:' \
		src/Makefile.orig > src/Makefile
	patch -p1 < ${FILESDIR}/${PN}-${PV}-gentoo.diff
}

src_compile() {
	make -C src || die
}

src_install() {
	dobin analog ; newman analog.man analog.1

	dodoc README.txt Licence.txt analog.cfg
	dohtml -a html,gif,css,ico docs/*
	docinto examples ; dodoc examples/*
	docinto cgi ; dodoc anlgform.html anlgform.pl
	cp -a how-to ${D}/usr/share/doc/${PF}

	insinto /usr/share/analog/images ; doins images/*
	insinto /usr/share/analog/lang ; doins lang/*
	dodir /var/log/analog
	dosym /usr/share/analog/images /var/log/analog/images
	insinto /etc/analog ; doins ${FILESDIR}/analog.cfg
}
