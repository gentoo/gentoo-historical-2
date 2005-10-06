# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfcegui4/libxfcegui4-4.2.2-r1.ebuild,v 1.1 2005/10/06 04:32:04 bcowan Exp $

DESCRIPTION="Libraries for Xfce 4"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="~xfce-base/libxfce4util-${PV}"

inherit xfce4 eutils

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/taskbar-gtk-2.8.patch
}
