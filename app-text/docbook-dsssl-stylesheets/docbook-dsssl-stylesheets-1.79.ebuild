# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-dsssl-stylesheets/docbook-dsssl-stylesheets-1.79.ebuild,v 1.3 2005/07/07 04:58:52 vapier Exp $

inherit sgml-catalog

MY_P=${P/-stylesheets/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="DSSSL Stylesheets for DocBook."
HOMEPAGE="http://docbook.sourceforge.net/projects/dsssl/index.html"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 s390 ~sparc x86"
IUSE=""

RDEPEND="app-text/sgml-common"

pkg_setup() {
	sgml-catalog_cat_include "/etc/sgml/dsssl-docbook-stylesheets.cat" \
		"/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog"
	sgml-catalog_cat_include "/etc/sgml/sgml-docbook.cat" \
		"/etc/sgml/dsssl-docbook-stylesheets.cat"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/${PN}-1.77.Makefile Makefile
}

src_compile() {
	return 0
}

src_install() {
	make \
		BINDIR="${D}/usr/bin" \
		DESTDIR="${D}/usr/share/sgml/docbook/dsssl-stylesheets-${PV}" \
		install || die

	dodir /usr/share/sgml/stylesheets/dsssl/

	if [ -d /usr/share/sgml/stylesheets/dsssl/docbook ] &&
		[ ! -L /usr/share/sgml/stylesheets/dsssl/docbook ]
	then
		ewarn "Not linking /usr/share/sgml/stylesheets/dsssl/docbook to"
		ewarn "/usr/share/sgml/docbook/dsssl-stylesheets-${PV}"
		ewarn "as directory already exists there.  Will assume you know"
		ewarn "what you're doing."
		return 0
	fi

	dosym /usr/share/sgml/docbook/dsssl-stylesheets-${PV} \
		/usr/share/sgml/stylesheets/dsssl/docbook

	dodoc BUGS ChangeLog README RELEASE-NOTES.txt WhatsNew
}
