# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-i18n/manpages-fr/manpages-fr-0.9.5.ebuild,v 1.2 2002/11/04 17:31:28 seemant Exp $

MY_P=${PN/pages/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A somewhat comprehensive collection of french Linux man pages"
SRC_URI="http://fr.tldp.org/${MY_P}-${PV}.tar.gz"
HOMEPAGE="http://fr.tldp.org"
KEYWORDS="x86 ppc"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="sys-apps/gzip"
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
