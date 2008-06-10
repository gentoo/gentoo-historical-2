# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/linux-atm/linux-atm-2.5.0.ebuild,v 1.2 2008/06/10 17:21:11 mrness Exp $

inherit eutils libtool flag-o-matic

DESCRIPTION="Tools for ATM"
HOMEPAGE="http://linux-atm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
RESTRICT="test"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-glibc28.patch

	sed -i '/#define _LINUX_NETDEVICE_H/d' \
		src/arpd/*.c || die "sed command on arpd/*.c files failed"
	sed -i 's:cp hosts.atm /etc:cp hosts.atm ${DESTDIR}/etc:' \
		src/config/Makefile.in || die "sed command on Makefile.in failed"

	elibtoolize
}

src_compile() {
	append-flags -fno-strict-aliasing

	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc README NEWS THANKS AUTHORS BUGS ChangeLog
	dodoc doc/README* doc/atm*
}
