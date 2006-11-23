# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/inputd/inputd-0.0.5-r1.ebuild,v 1.2 2006/11/23 11:41:00 opfer Exp $

inherit eutils

DESCRIPTION="inputd is a user-space daemon to emulate key presses trough other
key combinations"
HOMEPAGE="http://hansmi.ch/software/inputd"
SRC_URI="http://hansmi.ch/download/inputd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.8
	>=sys-kernel/linux-headers-2.6.16"
RDEPEND="sys-fs/udev"

src_install() {
	emake DESTDIR=${D} install || die 'installation failed.'

	newinitd ${FILESDIR}/inputd.init inputd
	dodoc README FAQ NEWS

	insinto /etc
	doins doc/inputd.conf
}

