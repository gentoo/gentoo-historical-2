# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/beecrypt/beecrypt-3.1.0.ebuild,v 1.6 2003/11/13 14:21:31 tuxus Exp $

DESCRIPTION="Beecrypt is a general-purpose cryptography library."
HOMEPAGE="http://sourceforge.net/projects/beecrypt"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="LGPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha mips"
SLOT="0"

DEPEND="python? ( =dev-lang/python-2.2* )
		!<app-arch/rpm-4.2.1"

IUSE="python"

src_compile() {
	econf \
		`use_with python` \
		--enable-shared \
		--enable-static || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	# Not needed
	rm -f ${D}/usr/lib/python*/site-packages/_bc.*a
	dodoc BUGS README BENCHMARKS NEWS || die "dodoc failed"
}
