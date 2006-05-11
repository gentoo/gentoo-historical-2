# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/wammu/wammu-0.13.ebuild,v 1.2 2006/05/11 21:14:51 mrness Exp $

inherit distutils

DESCRIPTION="front-end for gammu (Nokia and other mobiles)"
HOMEPAGE="http://www.cihar.com/gammu/wammu/"
SRC_URI="http://www.cihar.com/gammu/wammu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bluetooth"

#gnome-bluetooth is used for additional functionality - see bug #101067
RDEPEND=">=dev-python/wxpython-2.4.1.2
	>=dev-python/python-gammu-0.12
	>=app-mobilephone/gammu-1.05
	bluetooth? (
		net-wireless/gnome-bluetooth
		!amd64? ( dev-python/pybluez )
	)"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_compile() {
	# SKIPWXCHECK: else 'import wx' results in
	# Xlib: connection to ":0.0" refused by server
	SKIPWXCHECK=yes distutils_src_compile
}

src_install() {
	DOCS="AUTHORS FAQ NEWS"
	SKIPWXCHECK=yes distutils_src_install
}
