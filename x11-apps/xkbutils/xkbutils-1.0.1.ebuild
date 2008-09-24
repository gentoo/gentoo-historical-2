# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbutils/xkbutils-1.0.1.ebuild,v 1.7 2008/09/24 08:41:15 aballier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xkbutils application"
KEYWORDS="amd64 arm ~mips ~ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd"
IUSE="xprint"
RDEPEND="x11-libs/libxkbfile
	x11-libs/libXaw"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"

pkg_setup() {
	if use xprint && ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}
