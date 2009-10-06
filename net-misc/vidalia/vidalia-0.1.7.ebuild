# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vidalia/vidalia-0.1.7.ebuild,v 1.2 2009/10/06 19:06:15 ayoy Exp $

EAPI="2"
inherit eutils qt4 cmake-utils
# cmake-utils needs to be last, so we get its src_compile()

DESCRIPTION="Qt 4 front-end for Tor"
HOMEPAGE="http://www.vidalia-project.net/"
SRC_URI="http://www.vidalia-project.net/dist/${P}.tar.gz"

LICENSE="|| ( GPL-3 GPL-2 ) openssl"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4[debug?]"
RDEPEND="${DEPEND}
	net-misc/tor"

DOCS="CHANGELOG CREDITS README"

pkg_postinst() {
	echo
	ewarn "To have vidalia starting tor, you probably have to copy"
	ewarn "/etc/tor/torrc.sample to the users ~/.tor/torrc and comment"
	ewarn "the settings there and change the socks. Also, in vidalia"
	ewarn "change the default user under which tor will run."
	echo
}
