# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyorbit/pyorbit-1.99.3.ebuild,v 1.1 2003/02/09 18:28:43 foser Exp $

# debug since its a devel release
inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="ORBit2 bindings for Python"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"
LICENSE="LGPL-2.1"

DEPEND=">=dev-lang/python-2.2
	>=gnome-base/ORBit2-2.4.4"

SLOT="0"
RDEPEND="${DEPEND} >=dev-util/pkgconfig-0.12.0"
KEYWORDS="~x86"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
