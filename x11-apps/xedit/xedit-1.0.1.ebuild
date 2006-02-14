# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xedit/xedit-1.0.1.ebuild,v 1.2 2006/02/14 21:10:26 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xedit application"
KEYWORDS="~amd64 ~mips ~ppc64 ~sparc ~x86"
IUSE="xprint"
RDEPEND="x11-libs/libXprintUtil
	x11-libs/libXaw
	xprint? ( x11-libs/libXprintUtil )"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"

pkg_setup() {
	if use xprint && ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}

#src_compile() {
#	x-modular_src_configure
#	emake -j1 || die "emake failed"
#}
