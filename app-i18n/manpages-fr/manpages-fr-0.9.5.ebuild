# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/manpages-fr/manpages-fr-0.9.5.ebuild,v 1.9 2003/11/14 21:24:12 seemant Exp $

MY_P=${PN/pages/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A somewhat comprehensive collection of french Linux man pages"
SRC_URI="http://fr.tldp.org/${MY_P}-${PV}.tar.gz"
HOMEPAGE="http://fr.tldp.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="app-arch/gzip"
RDEPEND="sys-apps/man"

src_compile() {
	for x in man?
	do
		gzip ${S}/${x}/* || die
	done
}

src_install() {
	for x in man?
	do
		dodir /usr/share/man/fr/${x}
		install -m 644 ${S}/${x}/* ${D}/usr/share/man/fr/${x}
	done
}
