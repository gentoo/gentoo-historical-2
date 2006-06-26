# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vde/vde-2.0.2.ebuild,v 1.2 2006/06/26 09:17:38 genstef Exp $

inherit eutils

DESCRIPTION="vde2 is a virtual distributed ethernet emulator for emulators like qemu, bochs, and uml."
SRC_URI="mirror://sourceforge/vde/${P}.tar.bz2"
HOMEPAGE="http://vde.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/vde.init vde
	newconfd "${FILESDIR}"/vde.conf vde

	dodoc INSTALL README
}

pkg_postinst() {
	# default group already used in kqemu
	enewgroup qemu
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as an user be sure to set a group in /etc/conf.d/vde"
	einfo "Users of the group can then run: $ vdeq qemu -sock /var/run/vde.ctl ..other opts"
}
