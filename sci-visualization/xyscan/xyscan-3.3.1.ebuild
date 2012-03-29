# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/xyscan/xyscan-3.3.1.ebuild,v 1.1 2012/03/29 18:32:05 bicatali Exp $

EAPI=4
LANGS="fr"

inherit eutils qt4-r2 versionator

MY_PV=$(replace_version_separator 2 '')

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="http://star.physics.yale.edu/~ullrich/xyscanDistributionPage/"
SRC_URI="http://star.physics.yale.edu/~ullrich/${PN}DistributionPage/${MY_PV}/${PN}-${MY_PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e "s:qApp->applicationDirPath() + \"/../docs\":\"${EPREFIX}/usr/share/doc/${PF}/html\":" \
		xyscanWindow.cpp || die "Failed to fix docs path"
	rm -f moc_xyscanAbout.cpp moc_xyscanHelpBrowser.cpp moc_xyscanWindow.cpp
}

src_install() {
	exeinto /usr/bin
	doexe xyscan

	insinto /usr/share/doc/${PF}/html
	doins -r docs/en

	use linguas_fr && doins -r docs/fr

	newicon images/xyscanIcon.png xyscan.png
	make_desktop_entry xyscan "xyscan data point extractor"
}
