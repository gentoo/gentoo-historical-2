# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyorbit/pyorbit-2.0.0.ebuild,v 1.7 2004/02/29 03:47:52 jhuebel Exp $

# debug since its a devel release
inherit gnome2 debug

DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~ppc alpha sparc amd64"
IUSE=""

RDEPEND=">=dev-lang/python-2.2
	>=gnome-base/ORBit2-2.4.4"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
