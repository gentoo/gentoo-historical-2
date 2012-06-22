# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xpyb/xpyb-1.3.1.ebuild,v 1.2 2012/06/22 21:09:10 ago Exp $

EAPI=4

PYTHON_DEPEND="2"
inherit python xorg-2

#EGIT_REPO_URI="git://anongit.freedesktop.org/git/xcb/xpyb"
SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"
DESCRIPTION="XCB-based Python bindings for the X Window System"
HOMEPAGE="http://xcb.freedesktop.org/"

KEYWORDS="amd64 ~x86"
IUSE="selinux"

RDEPEND=">=x11-libs/libxcb-1.7
	>=x11-proto/xcb-proto-1.7.1"
DEPEND="${RDEPEND}"

DOCS=( NEWS README )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable selinux xselinux)
	)
}
