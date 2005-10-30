# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/commoncpp2/commoncpp2-1.3.20.ebuild,v 1.1 2005/10/30 20:33:38 arj Exp $

DESCRIPTION="GNU Common C++ is a C++ framework offering portable support for threading, sockets, file access, daemons, persistence, serial I/O, XML parsing, and system services"
SRC_URI="mirror://sourceforge/gnutelephony/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/commoncpp/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="xml2 doc"

DEPEND="xml2? ( >=dev-libs/libxml2-2.6.19 )
	doc? ( >=app-doc/doxygen-1.3.6 )"

src_compile() {
	# Save some time
	! use doc && \
		sed "s/^DOXYGEN=.*/DOXYGEN=no/" <configure >tmp && \
		cat tmp >configure

	econf $(use_with xml2 xml) || die
	emake || die
}

src_install () {
	einstall || die

	dodoc AUTHORS INSTALL NEWS ChangeLog README \
		THANKS TODO COPYING COPYING.addendum

	# Only install html docs
	# man and latex available, but seems a little wasteful
	use doc && dohtml doc/html/*
}
