# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web/twisted-web-0.5.0-r1.ebuild,v 1.5 2006/04/03 21:44:57 gustavoz Exp $

MY_PACKAGE=Web

inherit twisted eutils

DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sh sparc ~x86"

DEPEND=">=dev-python/twisted-2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-tests-2.2-compat.patch"
}
