# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/traydevice/traydevice-1.6.2-r1.ebuild,v 1.2 2013/05/11 22:24:52 ssuominen Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A little desktop application displaying systray icon for UDisks"
HOMEPAGE="http://savannah.nongnu.org/projects/traydevice/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	sys-fs/udisks:2"
DEPEND="app-text/docbook2X"

src_compile() {
	return 0
}

python_install() {
	distutils-r1_python_install \
		--prefix=/usr \
		--install-data=/usr/share/${PN} \
		--install-man=/usr/share/man \
		--docbook2man=docbook2man.pl

	rm -f "${ED}"/usr/share/${PN}/doc/*.txt
}
