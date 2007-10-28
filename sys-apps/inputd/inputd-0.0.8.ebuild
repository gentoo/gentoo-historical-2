# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/inputd/inputd-0.0.8.ebuild,v 1.3 2007/10/28 13:58:07 phreak Exp $

inherit eutils

DESCRIPTION="inputd is a user-space daemon to emulate key presses trough other
key combinations"
HOMEPAGE="http://hansmi.ch/software/inputd"
SRC_URI="http://hansmi.ch/download/inputd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~ppc64"
IUSE=""

DEPEND=">=dev-libs/glib-2.8
	>=sys-kernel/linux-headers-2.6.16"
RDEPEND="sys-fs/udev
	virtual/logger"

src_install() {
	emake DESTDIR=${D} install || die 'installation failed.'

	newinitd ${FILESDIR}/inputd.init inputd
	dodoc README doc/FAQ NEWS

	insinto /etc
	doins doc/inputd.conf
}
