# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ivman/ivman-0.3-r1.ebuild,v 1.3 2005/01/20 20:13:04 genstef Exp $

inherit eutils

DESCRIPTION="Daemon to mount/unmount devices, based on info from HAL"
HOMEPAGE="http://ivman.sf.net"
SRC_URI="mirror://sourceforge/ivman/${P}.tar.gz
		usb? ( http://code.mizzenblog.com/ivman/ivman_20041211.usb.diff.gz )"

SLOT="0"
LICENSE="QPL"
KEYWORDS="~amd64 ~x86"

IUSE="debug usb"

RDEPEND=">=dev-libs/glib-2.2
	 dev-libs/libxml2
	 >=sys-apps/hal-0.2.98"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.5
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-cvs.update
	useq usb && epatch ../ivman_20041211.usb.diff
}

src_compile() {
	econf `use_enable debug` || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	exeinto /etc/init.d/
	newexe ${FILESDIR}/${P}.init ivman
}
