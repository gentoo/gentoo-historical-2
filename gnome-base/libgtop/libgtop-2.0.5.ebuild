# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgtop/libgtop-2.0.5.ebuild,v 1.9 2004/02/18 13:48:03 agriffis Exp $

inherit gnome2

DESCRIPTION="A library that proivdes top functionality to applications"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

IUSE=""
SLOT="2"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"

RDEPEND=">=dev-libs/glib-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL LIBGTOP-VERSION NEWS README RELNOTES*"

