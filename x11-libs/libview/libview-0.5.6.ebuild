# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libview/libview-0.5.6.ebuild,v 1.1 2005/12/23 21:36:39 compnerd Exp $

inherit gnome2

DESCRIPTION="VMware's Incredibly Exciting Widgets"
HOMEPAGE="http://view.sourceforge.net"
SRC_URI="mirror://sourceforge/view/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.0
		 >=dev-cpp/gtkmm-2.4"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"
