# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libsrs2/libsrs2-1.0.16.ebuild,v 1.2 2007/03/18 04:21:49 genone Exp $

DESCRIPTION="libsrs2 is the next generation Sender Rewriting Scheme library"
HOMEPAGE="http://www.libsrs2.org/"
SRC_URI="http://www.libsrs2.org/srs/libsrs2-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc"
RDEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"

	dodoc AUTHORS COPYING INSTALL NEWS README
}

pkg_postinst() {
	elog "${P} was successfully installed."
	elog "Please read the associated docs for help."
	elog "Or visit the website @ ${HOMEPAGE}"
	echo
	ewarn "This package is still in unstable."
	ewarn "Please report bugs to http://bugs.gentoo.org/"
	ewarn "However, please do an advanced query to search for bugs"
	ewarn "before reporting. This will keep down on duplicates."
}
