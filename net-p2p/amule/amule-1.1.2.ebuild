# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/amule/amule-1.1.2.ebuild,v 1.6 2004/02/28 09:12:38 eradicator Exp $

MY_P=${P/m/M}
S=${WORKDIR}/${MY_P}

DESCRIPTION="aNOTHER wxWindows based eMule P2P Client"
HOMEPAGE="http://sourceforge.net/projects/amule"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

RDEPEND=">=x11-libs/wxGTK-2.4.1
	>=sys-libs/zlib-1.1.4"
DEPEND="$RDEPEND
	>=sys-devel/autoconf-2.58"

pkg_setup() {
	if wx-config --cppflags | grep gtk2u >& /dev/null; then
		einfo "${PN} will not build if wxGTK was compiled"
		einfo "with unicode support.  If you are using a version of"
		einfo "wxGTK <= 2.4.2, you must set USE=-gtk2.  In newer versions,"
		einfo "you must set USE=-unicode."
		die "wxGTK must be re-emerged without unicode suport"
	fi
}

src_compile () {
	export WANT_AUTOCONF='2.5'
	export WANT_AUTOMAKE='1.7'
	./autogen.sh
	econf || die
	MAKEOPTS="${MAKEOPTS} -j1" emake || die
}

src_install () {
	einstall || die
}
