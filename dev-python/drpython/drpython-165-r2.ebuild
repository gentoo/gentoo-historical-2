# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/drpython/drpython-165-r2.ebuild,v 1.1 2008/02/24 17:53:32 dev-zero Exp $

EAPI="1"

inherit distutils eutils multilib

DESCRIPTION="A powerful cross-platform IDE for Python"
HOMEPAGE="http://drpython.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-python/wxpython:2.6"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_unpack() {
	distutils_src_unpack
	epatch \
		"${FILESDIR}/${P}-wxversion.patch" \
		"${FILESDIR}/${P}-tabswitch.patch"
}

src_install() {
	distutils_python_version

	local destdir="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
	dodir  ${destdir}/bitmaps/{16,24}
	cp -R bitmaps "${D}/${destdir}/" || die "failed to cp bitmaps"

	distutils_src_install

	# Windows-only setup script:
	rm "${D}/usr/bin/postinst.py"

	make_wrapper drpython "python ${destdir}/drpython_wx26.py"
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "See the DrPython homepage for 20+ available plugins:"
	elog "http://sourceforge.net/project/showfiles.php?group_id=83074"
}
