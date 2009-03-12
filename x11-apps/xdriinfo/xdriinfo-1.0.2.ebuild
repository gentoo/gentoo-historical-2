# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xdriinfo/xdriinfo-1.0.2.ebuild,v 1.9 2009/03/12 10:15:25 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="query configuration information of DRI drivers"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 ~sh sparc x86 ~x86-fbsd"
RDEPEND="x11-libs/libX11
	virtual/opengl"
DEPEND="${RDEPEND}
	app-admin/eselect-opengl
	x11-proto/glproto"

pkg_setup() {
	# Bug #138920
	ewarn "Forcing on xorg-x11 for header sanity..."
	OLD_IMPLEM="$(eselect opengl show)"
	eselect opengl set --impl-headers xorg-x11
}

pkg_postinst() {
	echo
	eselect opengl set ${OLD_IMPLEM}
}
