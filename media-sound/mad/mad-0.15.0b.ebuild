# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mad/mad-0.15.0b.ebuild,v 1.10 2004/04/26 22:17:11 geoman Exp $

IUSE=""

HOMEPAGE="http://mad.sourceforge.net/"
DESCRIPTION="The MAD metapackage for libmad, libid3tag, and madplay"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha sparc hppa mips ia64 ~amd64"

DEPEND="~media-libs/libmad-${PV}
	~media-libs/libid3tag-${PV}
	~media-sound/madplay-${PV}"
