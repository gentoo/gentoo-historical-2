# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sgmltools-lite/sgmltools-lite-3.0.3.ebuild,v 1.13 2002/10/04 05:07:58 vapier Exp $

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/sgmltools-lite/${P}.tar.gz
		 mirror://sourceforge/sgmltools-lite/nw-eps-icons-0.0.1.tar.gz"

HOMEPAGE="http://sgmltools-lite.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
DESCRIPTION="Python interface to SGML software specificially in a DocBook/OpenJade environment.  Provides sgml2{html,txt,rtf,dvi,ps}"

DEPEND="virtual/python
	app-text/sgml-common
	=app-text/docbook-sgml-dtd-3.1
	app-text/docbook-dsssl-stylesheets
	app-text/jadetex
	app-text/openjade
	net-www/lynx"
KEYWORDS="x86 ppc sparc sparc64"

src_unpack() {
	cd ${WORKDIR}
	unpack ${P}.tar.gz
	cd ${S}
	unpack nw-eps-icons-0.0.1.tar.gz
	patch -p0 <${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	./configure --prefix=/usr || die
	make || die
}

src_install () {
	mv bin/gensgmlenv bin/gensgmlenv_orig
	sed -e "s#/etc/sgml/sgml.env#${D}/etc/sgml/sgml.env#g" \
		-e "s#/etc/sgml/sgml.cenv#${D}/etc/sgml/sgml.cenv#g" \
		bin/gensgmlenv_orig > bin/gensgmlenv
	make DESTDIR=${D} install

	cd ${S}/bin
	chmod a+x ./gensgmlenv
	./gensgmlenv
	cd /etc/sgml
	dodir /etc/env.d
	cat sgml.env | grep = > ${D}/etc/env.d/93sgmltools-lite
	rm sgml.env sgml.cenv

	cd ${S}/nw-eps-icons-0.0.1/images
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images
	doins *.eps
	insinto /usr/share/sgml/docbook/dsssl-stylesheets/images/callouts
	cd callouts
	doins *.eps
}
