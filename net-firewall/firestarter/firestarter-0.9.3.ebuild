# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/firestarter/firestarter-0.9.3.ebuild,v 1.1 2004/06/04 18:56:49 mr_bones_ Exp $

inherit gnome2

DESCRIPTION="GUI for iptables firewall setup and monitor."
HOMEPAGE="http://firestarter.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnome-2
	net-firewall/iptables
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.21"

pkg_setup() {
	G2CONF=$(use_enable nls)
	DOCS="AUTHORS ChangeLog CREDITS INSTALL README TODO"
}
