# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/powerpc-utils/powerpc-utils-1.1.3-r7.ebuild,v 1.8 2004/07/01 21:36:41 eradicator Exp $

S=${WORKDIR}/${P}
DEBRV=7
MY_P="${PN}_${PV}"
DESCRIPTION="PowerPC utils; nvsetenv"
SRC_URI="http://http.us.debian.org/debian/pool/main/p/powerpc-utils/${MY_P}.orig.tar.gz
	http://http.us.debian.org/debian/pool/main/p/powerpc-utils/${MY_P}-${DEBRV}.diff.gz"
HOMEPAGE="http://http.us.debian.org/debian/pool/main/p/powerpc-utils/"
KEYWORDS="ppc -x86 -amd64 -alpha -hppa -mips -sparc ppc64"
DEPEND="virtual/libc"
RDEPEND=""
SLOT="0"
LICENSE="GPL-2"

src_unpack() {
	cd ${WORKDIR}
	unpack powerpc-utils_${PV}.orig.tar.gz
	mv pmac-utils ${P}
	cd ${S}
	cat ${DISTDIR}/powerpc-utils_${PV}-${DEBRV}.diff.gz | gzip -dc | patch -p1 || die
	cd ${WORKDIR}
	chown -R 0:0 *
	chmod -R a+r-w+X,u+w *
}

src_compile() {
	emake nvsetenv trackpad clock mousemode backlight || die
}

src_install() {
	into /usr
	dosbin nvsetenv trackpad clock mousemode backlight || die
}
