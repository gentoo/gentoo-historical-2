# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxcb/libxcb-1.3.ebuild,v 1.1 2009/06/07 21:06:29 remi Exp $

EAPI="2"

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X C-language Bindings library"
HOMEPAGE="http://xcb.freedesktop.org/"
SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"
LICENSE="X11"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc selinux"

RDEPEND="x11-libs/libXau
	x11-libs/libXdmcp
	dev-libs/libpthread-stubs"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-libs/libxslt
	>=x11-proto/xcb-proto-1.5
	>=dev-lang/python-2.5[xml]"

pkg_setup() {
	CONFIGURE_OPTIONS="$(use_enable doc build-docs)
		$(use_enable selinux xselinux)
		--enable-xinput"
}

src_install() {
	x-modular_src_install
	dobin "${FILESDIR}"/xcb-rebuilder.sh || die
}

pkg_postinst() {
	x-modular_pkg_postinst

	ewarn "libxcb-1.2 removed libxcb-xlib.so. Run xcb-rebuilder.sh to rebuild"
	ewarn "packages that broke. revdep-rebuild may also work."
	ebeep 5
	epause 5
}
