# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnet/gnet-2.0.3.ebuild,v 1.8 2004/05/29 16:15:26 pvdabeel Exp $

inherit gnome2

DESCRIPTION="GNet network library."
SRC_URI="http://www.gnetlibrary.org/src/${P}.tar.gz"
HOMEPAGE="http://www.gnetlibrary.org/"

IUSE=""
SLOT="2"
LICENSE="LGPL-2"
KEYWORDS="x86 hppa sparc ppc"

# yes, the >= is correct, this software can use both glib 1.2 and 2.0!
RDEPEND=">=dev-libs/glib-1.2.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

G2CONF=" --with-html-dir=${D}/usr/share/doc/${PF}"

DOCS="AUTHORS BUGS ChangeLog COPYING NEWS README TODO"
