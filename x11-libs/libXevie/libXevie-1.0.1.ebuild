# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXevie/libXevie-1.0.1.ebuild,v 1.9 2006/10/01 16:59:57 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Xevie library"

KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-proto/xproto
	x11-proto/evieext"
DEPEND="${RDEPEND}"
