# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_lisp/mod_lisp-2.42.ebuild,v 1.2 2005/04/16 20:59:25 mkennedy Exp $

inherit apache-module

DESCRIPTION="mod_lisp is an Apache module to easily write web applications in Common Lisp"
HOMEPAGE="http://www.fractalconcept.com/asp/sdataQIceRsMvtN9fDM==/sdataQuvY9x3g$ecX"
SRC_URI="mirror://gentoo/${P}.c"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""

DEPEND=""

APACHE1_MOD_CONF="10_${PN}"
APACHE1_MOD_DEFINE="LISP"

need_apache1

src_unpack() {
	mkdir ${S}
	cp ${DISTDIR}/${P}.c ${S}/${PN}.c
}
