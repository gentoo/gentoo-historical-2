# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xcursorgen/xcursorgen-1.0.3.ebuild,v 1.8 2010/01/18 19:09:46 armin76 Exp $

inherit x-modular

DESCRIPTION="create an X cursor file from a collection of PNG images"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXcursor
	=media-libs/libpng-1.2*"
DEPEND="${RDEPEND}"
