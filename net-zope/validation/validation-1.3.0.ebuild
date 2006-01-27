# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/validation/validation-1.3.0.ebuild,v 1.2 2006/01/27 02:48:48 vapier Exp $

inherit zproduct

MASTER_PN=archetypes
DESCRIPTION="Data validation package, originally designed for Archetypes"
HOMEPAGE="http://www.sourceforge.net/projects/${MASTER_PN}"
SRC_URI="mirror://sourceforge/${MASTER_PN}/${P}-8.tgz"

LICENSE="GPL-2"
SLOT="1.3"
KEYWORDS="~ppc ~x86"

RDEPEND=">=net-zope/cmf-1.4.7"

ZPROD_LIST="validation"

src_install() {
	zproduct_src_install all
}

pkg_postinst() {
	zproduct_pkg_postinst
	ewarn "Please be warned that it should not be used together with dev-python/validation !"
}
