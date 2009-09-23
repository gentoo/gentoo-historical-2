# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/fusesmb/fusesmb-0.8.7.ebuild,v 1.6 2009/09/23 18:35:52 patrick Exp $

inherit eutils

DESCRIPTION="Instead of mounting one Samba share at a time, you mount all workgroups, hosts and shares at once."
HOMEPAGE="http://www.ricardis.tudelft.nl/~vincent/fusesmb/"
SRC_URI="http://www.ricardis.tudelft.nl/~vincent/fusesmb/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.3
		>=net-fs/samba-3.0"

DEPEND="${RDEPEND}
	sys-devel/libtool
	sys-devel/make"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:\(FUSE_USE_VERSION.\)23:\122:" config* || die "sed failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README fusesmb.conf.ex
}

pkg_postinst() {
	elog
	elog "For quick usage, exec:"
	elog "'modprobe fuse'"
	elog "'fusesmb -oallow_other /mnt/samba'"
	elog
}
