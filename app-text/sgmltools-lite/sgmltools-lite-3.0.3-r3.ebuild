# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sgmltools-lite/sgmltools-lite-3.0.3-r3.ebuild,v 1.10 2002/12/09 04:17:45 manson Exp $

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/sgmltools-lite/${P}.tar.gz
		 mirror://sourceforge/sgmltools-lite/nw-eps-icons-0.0.1.tar.gz"
HOMEPAGE="http://sgmltools-lite.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
DESCRIPTION="Python interface to SGML software specificially in a DocBook/OpenJade environment."

DEPEND="virtual/python
	app-text/sgml-common
	=app-text/docbook-sgml-dtd-3.1
	app-text/docbook-dsssl-stylesheets
	app-text/jadetex
	app-text/openjade
	net-www/lynx"

KEYWORDS="x86 ppc sparc "
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

src_install() {
	make	\
		prefix=${D}/usr	\
		exec-prefix=${D}/usr	\
		datadir=${D}/usr/share	\
		bindir=${D}/usr/bin	\
		sysconfdir=${D}/etc	\
		mandir=${D}/usr/share/man	\
		etcdir=${D}/etc/sgml	\
		install || die

	dodoc COPYING ChangeLog POSTINSTALL README*
	dohtml -r .
	
	cd ${WORKDIR}/nw-eps-icons-0.0.1/images
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images
	doins *.eps
	
	cd callouts
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images/callouts
	doins *.eps
	
	rm ${D}/etc/sgml/catalog.{suse,rh62}
}

pkg_postinst() {

	gensgmlenv
	grep -v export /etc/sgml/sgml.env > /etc/env.d/93sgmltools-lite
}
