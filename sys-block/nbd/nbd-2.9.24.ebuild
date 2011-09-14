# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/nbd/nbd-2.9.24.ebuild,v 1.1 2011/09/14 23:58:33 radhermit Exp $

EAPI="4"

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="http://nbd.sourceforge.net/"
SRC_URI="mirror://sourceforge/nbd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--enable-lfs \
		--enable-syslog
}

src_compile() {
	emake
	emake -C gznbd
}

src_install() {
	default
	dobin gznbd/gznbd
}
