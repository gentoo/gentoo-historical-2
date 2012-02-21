# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/nonolith-connect/nonolith-connect-1.0.1.ebuild,v 1.1 2012/02/21 13:41:48 chainsaw Exp $

EAPI=4

inherit base scons-utils toolchain-funcs

DESCRIPTION="CEE (Control - Experiment - Explore) analog multitool"
HOMEPAGE="http://www.nonolithlabs.com/cee/"
SRC_URI="http://apps.nonolithlabs.com/download/source/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/boost
	sys-fs/udev"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PV}-cflags-respect.patch" )

pkg_setup() {
	tc-export CC CXX
	enewuser nonolithd -1 -1 /dev/null usb
}

src_configure() {
	myesconsargs=(
		boost_static=0
	)
}

src_compile() {
	escons
}

src_install() {
	dobin nonolith-connect
	newinitd "${FILESDIR}/nonolith-connect.initd" nonolith-connect
	insinto /lib/udev
	doins "${FILESDIR}/60-nonolith-connect.rules"
}

pkg_postinst() {
	einfo "Consider adding nonolith-connect to the default runlevel."
	einfo "Please connect your CEE hardware, start nonolith-connect "
	einfo "using the init script provided and then visit:"
	einfo "http://apps.nonolithlabs.com/setup"
}
