# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libmath++/libmath++-0.0.3.ebuild,v 1.1 2002/08/01 14:59:34 bass Exp $

DESCRIPTION="libmath++ is a template based math library, written in C++, for symbolic and numeric calculus applications"
HOMEPAGE="http://www.surakware.net/projects/libmath%2B%2B/index.xml"
SRC_URI="ftp://ftp.surakware.net/pub/unstable/releases/libmath%2B%2B/${P}.tar.gz"
LICENSE="GPL"
SLOT="1"
KEYWORDS="x86"

DEPEND=""

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
