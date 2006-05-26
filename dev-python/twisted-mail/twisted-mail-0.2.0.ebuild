# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-mail/twisted-mail-0.2.0.ebuild,v 1.6 2006/05/26 17:38:45 marienz Exp $

MY_PACKAGE=Mail

inherit twisted eutils

DESCRIPTION="A Twisted Mail library, server and client."

KEYWORDS="~alpha ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-python/twisted-2.1
	<dev-python/twisted-2.4
	>=dev-python/twisted-names-0.2.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-tests-2.2-compat.patch"
}
