# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgtop/libgtop-2.0.2-r1.ebuild,v 1.4 2003/08/13 15:57:06 obz Exp $

inherit gnome2 eutils

DESCRIPTION="library that proivdes top functionality to applications" 
HOMEPAGE="http://www.gnome.org/"
SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog  INSTALL LIBGTOP-VERSION NEWS README RELNOTES*"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-lt_version_fix.patch
}
