# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet/gnunet-0.6.1b.ebuild,v 1.4 2004/06/25 00:33:04 agriffis Exp $

inherit libtool

S="${WORKDIR}/GNUnet-${PV}"
DESCRIPTION="GNUnet is an anonymous, distributed, reputation based network."
HOMEPAGE="http://www.gnu.org/software/GNUnet/"
SRC_URI="mirror://gnu/${PN}/GNUnet-${PV}.tar.bz2"
RESTRICT="nomirror"

IUSE="ipv6"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-libs/openssl-0.9.6d
	>=sys-libs/gdbm-1.8.0
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=media-libs/libextractor-0.2.6"

src_compile() {
	elibtoolize
	econf `use_enable ipv6` || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog PLATFORMS README UPDATING
	insinto /etc
	newins contrib/gnunet.conf.root gnunet.conf
	docinto contrib
	dodoc contrib/*
}

pkg_postinst() {
	use ipv6 && ewarn "ipv6 support is -very- experimental and prone to bug"
	einfo
	einfo "now copy an appropriate config file from"
	einfo "/usr/share/doc/${P}/contrib"
	einfo "to ~/.gnunet/gnunet.conf"
	einfo
}
