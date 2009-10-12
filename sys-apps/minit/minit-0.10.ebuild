# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/minit/minit-0.10.ebuild,v 1.1 2009/10/12 15:01:52 vostorga Exp $

inherit eutils

DESCRIPTION="a small yet feature-complete init"
HOMEPAGE="http://www.fefe.de/minit/"
SRC_URI="http://dl.fefe.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/libowfat
		dev-libs/dietlibc"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/minit-0.10-fixes.diff
}

src_compile() {
	emake CFLAGS="${CFLAGS} -I/usr/include/libowfat" \
		LDFLAGS="${LDFLAGS}" DIET="${DIET}" || die
}

src_install() {
	emake install-files DESTDIR="${D}" || die
	mv "${D}"/sbin/shutdown "${D}"/sbin/minit-shutdown || die
	mv "${D}"/sbin/killall5 "${D}"/sbin/minit-killall5 || die
	rm "${D}"/sbin/init || die
	dodoc CHANGES README TODO
}

pkg_postinst() {
	[ -e /etc/minit/in ] || mkfifo "${ROOT}"/etc/minit/in
	[ -e /etc/minit/out ] || mkfifo "${ROOT}"/etc/minit/out
}
