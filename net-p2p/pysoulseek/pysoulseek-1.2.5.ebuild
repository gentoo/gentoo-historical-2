# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/pysoulseek/pysoulseek-1.2.5.ebuild,v 1.2 2004/04/18 01:39:00 tester Exp $

IUSE="oggvorbis"
inherit eutils distutils
MY_PN="${PN/soulseek/slsk}"
MY_PV="${PV/_/}"

MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="client for SoulSeek filesharing"
HOMEPAGE="http://www.sensi.org/~ak/pyslsk/
	http://thegraveyard.org/pyslsk/index.html"
SRC_URI="http://www.sensi.org/~ak/pyslsk/${MY_P}.tar.gz "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~hppa ~amd64"

DEPEND=">=dev-lang/python-2.1
	>=dev-python/wxPython-2.4.1.2
	>=x11-libs/wxGTK-2.4.1
	oggvorbis? ( dev-python/pyvorbis dev-python/pyogg )"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install
	insinto /usr/share/applications
	doins ${FILESDIR}/pysoulseek.desktop
}

pkg_postinst() {
	echo
	einfo "The hydriant patch no longer is, check nicotine from the same people"
	echo
}
