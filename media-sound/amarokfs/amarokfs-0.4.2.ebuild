# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarokfs/amarokfs-0.4.2.ebuild,v 1.1 2007/02/13 23:36:30 flameeyes Exp $

inherit qt3 kde-functions toolchain-funcs

need-kde 3

MY_PN="${PN/fs/FS}"
MY_P="${MY_PN}-qt3-${PV}"

DESCRIPTION="A full screen frontend for Amarok."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=52641"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/52641-${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND="media-sound/amarok"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	sed -i -e 's:/usr/local/:/usr/:' "${S}"/*.{pro,cpp} || die "sed for /usr/local failed."
	sed -i -e "s:Icon=.*:Icon=${MY_PN}:" "${S}/${MY_PN}.desktop" || die "fix desktop file failed."
	sed -i -e 's:/usr/share/icons/:\0hicolor/128x128/apps/:' "${S}/${MY_PN}-xml.pro" || die "fix icon installation failed"
	sed -i -e '/qDebug/s:" + \(func\|query\):%s", \1.data():' "${S}"/*.cpp || die "fix for qDebug() calls failed."
}

src_compile() {
	${QTDIR}/bin/qmake QMAKE="${QTDIR}/bin/qmake" || die "qmake failed"
	sed -i -e '/strip/d' Makefile || die "fix stripping failed."
	emake \
		CC="$(tc-getCC) ${CFLAGS}" \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		LINK="$(tc-getCXX) ${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake -j1 INSTALL_ROOT="${D}" install || die "emake install failed"
}
