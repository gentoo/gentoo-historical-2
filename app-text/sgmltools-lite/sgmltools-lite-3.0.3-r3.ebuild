# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/sgmltools-lite/sgmltools-lite-3.0.3-r3.ebuild,v 1.1 2002/03/31 12:26:38 seemant Exp $

S=${WORKDIR}/${P}
SRC_URI="http://prdownloads.sourceforge.net/sgmltools-lite/${P}.tar.gz
		 http://prdownloads.sourceforge.net/sgmltools-lite/nw-eps-icons-0.0.1.tar.gz"
HOMEPAGE="sgmltools-lite.sourceforge.net"
DESCRIPTION="Python interface to SGML software specificially in a DocBook/OpenJade environment."

DEPEND="virtual/python
	app-text/sgml-common
	=app-text/docbook-sgml-dtd-3.1
	app-text/docbook-dsssl-stylesheets
	app-text/jadetex
	app-text/openjade
	net-www/lynx"

src_compile() {
	./configure 	\
		--prefix=/usr \
		--exec-prefix=/usr	\
		--bindir=/usr/bin	\
		--sbindir=/usr/sbin	\
		--datadir=/usr/share	\
		--mandir=/usr/share/man	|| die
	
	make || die
}

src_install () {
	make	\
		prefix=${D}/usr	\
		exec-prefix=${D}/usr	\
		datadir=${D}/usr/share	\
		bindir=${D}/usr/bin	\
		sysconfdir=${D}/etc	\
		mandir=${D}/usr/share/man	\
		etcdir=${D}/etc/sgml	\
		install || die

	cd ${WORKDIR}/nw-eps-icons-0.0.1/images
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images
	doins *.eps
	
	cd callouts
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images/callouts
	doins *.eps
	
	dodoc COPYING ChangeLog POSTINSTALL README*
	dohtml -r .
	
	rm ${D}/etc/sgml/catalog.{suse,rh62}
}

pkg_postinst() {

	gensgmlenv
	grep -v export /etc/sgml/sgml.env > /etc/env.d/93sgmltools-lite
}
