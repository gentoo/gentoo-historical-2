# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/wordnet/wordnet-2.0.ebuild,v 1.5 2005/04/23 11:23:01 luckyduck Exp $

inherit eutils

DESCRIPTION="WordNet : a lexical database for the English language"
HOMEPAGE="http://www.cogsci.princeton.edu/~wn/"
SRC_URI="ftp://ftp.cogsci.princeton.edu/pub/wordnet/${PV}/WordNet-${PV}.tar.gz"
DEPEND="dev-lang/tcl
	dev-lang/tk"
LICENSE="Princeton"
IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
S=${WORKDIR}/WordNet-${PV}

src_unpack() {
	unpack $A
	epatch ${FILESDIR}/Makefiles.diff
}

src_compile() {
	MAKEOPTS="-e"
	PLATFORM=linux WN_ROOT=${T}/usr \
	WN_DICTDIR=${T}/usr/share/wordnet/dict \
	WN_MANDIR=${T}/usr/share/man \
	WN_DOCDIR=${T}/usr/share/doc/wordnet-${PV} \
	CFLAGS="${CFLAGS} -DUNIX -I${T}/usr/include" \
	emake SrcWorld || die
}

src_install() {
	cp -r ${T}/usr ${D}
}
