# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nevow/nevow-0.1.ebuild,v 1.5 2004/06/25 01:34:51 agriffis Exp $

inherit distutils

# for alphas,..
MY_PV="${PV/_alpha/alpha}"
DESCRIPTION="Nevow is a next-generation web application templating system, based on the ideas developed in the Twisted Woven package."
HOMEPAGE="http://www.nevow.com/"
SRC_URI="http://www.nevow.com/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~alpha"
IUSE=""

DEPEND=">=dev-python/twisted-1.2.0"

src_install() {
	distutils_src_install

	dodoc README

	# other docs are in subdirs so i use cp -r instead of insinto
	cp -r ${S}/doc ${D}/usr/share/doc/${PF}/
	cp -r ${S}/examples ${D}/usr/share/doc/${PF}/

	# FIXME:
	# should i install tutorial,pdfs,.. when USE="doc"?
}
