# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-dsssl-stylesheets/docbook-dsssl-stylesheets-1.77.ebuild,v 1.9 2003/02/13 09:34:24 vapier Exp $

MY_P=${P/-stylesheets/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="DSSSL Stylesheets for DocBook."
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.gz"
HOMEPAGE="http://www.sourceforge.net/docbook/"

RDEPEND="app-text/sgml-common"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/${P}.Makefile Makefile
}

src_install () {

	make \
		BINDIR="${D}/usr/bin" \
		DESTDIR="${D}/usr/share/sgml/docbook/dsssl-stylesheets-${PV}" \
		install || die

}

pkg_postinst() {
	if [ -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ]
	then
		install-catalog --add \
			/etc/sgml/dsssl-docbook-stylesheets.cat \
			/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog

		install-catalog --add \
			/etc/sgml/sgml-docbook.cat \
			/etc/sgml/dsssl-docbook-stylesheets.cat
	fi
}

pkg_prerm() {
	if [ -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ]
	then
		if [ -e /etc/sgml/dsssl-docbook-stylesheets.cat ]
		then
			install-catalog --remove \
				/etc/sgml/dsssl-docbook-stylesheets.cat \
				/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog
		fi
		if [ -e /etc/sgml/sgml-docbook.cat ]
		then
			install-catalog --remove \
				/etc/sgml/sgml-docbook.cat \
				/etc/sgml/dsssl-docbook-stylesheets.cat
		fi
	fi
}
