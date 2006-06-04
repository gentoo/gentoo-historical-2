# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web/twisted-web-0.6.0.ebuild,v 1.2 2006/06/04 02:43:34 ranger Exp $

MY_PACKAGE=Web

inherit twisted eutils

DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ppc64 ~sh ~sparc ~x86"

DEPEND=">=dev-python/twisted-2.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.5.0-root-skip.patch"
}
