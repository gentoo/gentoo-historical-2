# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgtop/libgtop-2.6.0.ebuild,v 1.8 2004/07/04 11:01:14 kloeri Exp $

inherit gnome2

DESCRIPTION="A library that proivdes top functionality to applications"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

IUSE=""
SLOT="2"
KEYWORDS="x86 ppc ~sparc alpha hppa amd64 ~ia64 mips"

RDEPEND=">=dev-libs/glib-2
	dev-libs/popt"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README RELNOTES*"

USE_DESTDIR="1"
