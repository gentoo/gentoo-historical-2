# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/socketstream/socketstream-0.3.0.ebuild,v 1.2 2004/03/14 12:28:58 mr_bones_ Exp $

DESCRIPTION="C++ Streaming sockets library"
SRC_URI="mirror://sourceforge/socketstream/${P}.tar.gz"
HOMEPAGE="http://socketstream.sourceforge.net/"

SLOT="0"

LICENSE="LGPL-2"
KEYWORDS="~x86 ~alpha ~ppc ~sparc ~hppa ~amd64"

DEPEND=""

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
