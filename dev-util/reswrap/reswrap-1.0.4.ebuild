# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/reswrap/reswrap-1.0.4.ebuild,v 1.1 2005/05/07 19:43:22 rphillips Exp $

FOX_COMPONENT="utils"
FOX_PV="1.0.53"

inherit fox

DESCRIPTION="Utility to wrap icon resources into C++ code, from the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~ia64 ~ppc ~ppc64 ~sparc"
IUSE=""

RDEPEND="virtual/libc"

FOXCONF="--disable-cups \
	--disable-jpeg \
	--without-opengl \
	--disable-png \
	--disable-tiff \
	--without-shm \
	--without-x \
	--disable-zlib"
