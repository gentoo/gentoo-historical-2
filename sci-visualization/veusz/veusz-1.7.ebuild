# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/veusz/veusz-1.7.ebuild,v 1.1 2010/04/01 19:05:59 grozin Exp $

EAPI=2
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_DEPEND="2"
inherit eutils distutils fdo-mime

DESCRIPTION="Qt based scientific plotting package with good Postscript output"
HOMEPAGE="http://home.gna.org/veusz/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

IUSE="doc examples fits"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

DEPEND="dev-python/numpy"
RDEPEND="${DEPEND}
	dev-python/PyQt4[X,svg]
	fits? ( dev-python/pyfits )"

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}
	if use examples; then
		doins -r examples || die "examples install failed"
	fi
	if use doc; then
		cd Documents
		insinto /usr/share/doc/${PF}
		doins manual.pdf
		insinto /usr/share/doc/${PF}/html
		doins -r manual.html manimages \
			|| die "doc install failed"
	fi
	newicon "${S}"/windows/icons/veusz_48.png veusz.png
	domenu "${FILESDIR}"/veusz.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/veusz.xml
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
}
