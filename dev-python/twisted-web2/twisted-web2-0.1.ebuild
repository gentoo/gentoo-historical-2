# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web2/twisted-web2-0.1.ebuild,v 1.1 2005/11/27 22:21:34 marienz Exp $

MY_PACKAGE=Web2

inherit twisted eutils

DESCRIPTION="An HTTP/1.1 Server Framework"

KEYWORDS="~x86"

DEPEND=">=dev-python/twisted-2"

# this is not in the standard location twisted.eclass expects
SRC_URI="http://tmrc.mit.edu/mirror/twisted/Web2/TwistedWeb2-0.1.tar.bz2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-tests-2.1-compat.patch"
}
