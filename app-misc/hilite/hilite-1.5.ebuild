# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hilite/hilite-1.5.ebuild,v 1.5 2004/08/09 23:26:46 ciaranm Exp $

HOMEPAGE="http://sourceforge.net/projects/hilite"
SRC_URI="mirror://gentoo/${PN}-${PV}.c"
DESCRIPTION="A utility which highlights stderr text in red"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="sparc mips ~amd64 ~x86 ~hppa"
S=${WORKDIR}

IUSE=""
DEPEND=""

src_unpack() {
	cp ${DISTDIR}/${A} ${WORKDIR}/
}

src_compile() {
	${CC:-gcc} ${CFLAGS} -o ${PN} ${PN}-${PV}.c \
		|| die "compile failed"
}

src_install() {
	dobin ${WORKDIR}/hilite
}

