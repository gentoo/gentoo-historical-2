# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/oer/oer-1.0.64.ebuild,v 1.3 2004/06/24 23:08:01 agriffis Exp $

inherit fixheadtails eutils

DESCRIPTION="Free to use GPL'd IRC bot"
HOMEPAGE="http://oer.equnet.org/"
SRC_URI="http://oer.equnet.org/${PN}-1.0-64.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}-dist

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-basename.patch

	ht_fix_file configure
}

src_compile() {
	econf || die "econf failed"
	# Bad configure script is forcing CFLAGS, so we pass our own
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin oer || die "dobin failed"
	dodoc CHANGELOG HELP README THANKS || die "dodoc failed"
	docinto sample-configuration
	dodoc sample-configuration/* || die "dodoc failed"
}

pkg_postinst() {
	einfo
	einfo "You can find a sample configuration file set in"
	einfo "/usr/share/doc/${PF}/sample-configuration"
	einfo
}
