# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.31_pre20070612.ebuild,v 1.1 2007/06/12 07:00:16 hollow Exp $

inherit eutils flag-o-matic

DESCRIPTION="A minimal libc"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="http://people.linux-vserver.org/~hollow/dietlibc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND=""

DIETHOME=/usr/diet

pkg_setup() {
	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# debug flags
	use debug && append-flags -g
}

src_compile() {
	emake prefix=${DIETHOME} CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	emake prefix=${DIETHOME} DESTDIR="${D}" install || die "make install failed"
	dobin "${D}"${DIETHOME}/bin/* || die "dobin failed"
	doman "${D}"${DIETHOME}/man/*/* || die "doman failed"
	rm -r "${D}"${DIETHOME}/{man,bin}
	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING
}
