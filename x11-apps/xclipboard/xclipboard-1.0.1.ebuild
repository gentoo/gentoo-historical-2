# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xclipboard/xclipboard-1.0.1.ebuild,v 1.7 2008/03/24 14:01:30 maekke Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="interchange between cut buffer and selection"
KEYWORDS="amd64 arm ~mips ~ppc ~ppc64 s390 sh ~sparc x86"
IUSE="xprint"
RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="$(use_enable xprint)"

pkg_setup() {
	if use xprint && ! built_with_use x11-libs/libXaw xprint; then
		die "Build x11-libs/libXaw with USE=xprint."
	fi
}
