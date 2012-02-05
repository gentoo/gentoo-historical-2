# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/xpra/xpra-0.0.7.35.ebuild,v 1.1 2012/02/05 15:38:59 xmw Exp $

EAPI=3

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
SUPPORT_PYTHON_ABIS="1"
inherit distutils eutils

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="http://xpra.org/"
SRC_URI="http://xpra.org/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg libnotify parti png server ssh"

COMMON_DEPEND="dev-python/pygtk:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	server? ( x11-libs/libXtst )
	server? ( x11-base/xorg-server[-minimal] )
	!x11-wm/parti"

RDEPEND="${COMMON_DEPEND}
	x11-apps/xmodmap
	parti? ( dev-python/ipython
		 dev-python/dbus-python )
	libnotify? ( dev-python/dbus-python )
	jpeg? ( dev-python/imaging )
	png? ( dev-python/imaging )
	ssh? ( net-misc/openssh )
	server? ( x11-base/xorg-server[xvfb] )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	server? ( dev-python/cython )"

src_prepare() {
	if ! use server; then
		epatch disable-posix-server.patch
	fi

	$(PYTHON -2) make_constants_pxi.py wimpiggy/lowlevel/constants.txt wimpiggy/lowlevel/constants.pxi || die
}
