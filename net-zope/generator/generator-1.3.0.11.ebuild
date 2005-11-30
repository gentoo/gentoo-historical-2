# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/generator/generator-1.3.0.11.ebuild,v 1.1 2004/12/04 20:08:58 radek Exp $

inherit zproduct

MASTER_PN=archetypes

DESCRIPTION="Widget generator package, originally designed for Archetypes."
WEBPAGE="http://www.sourceforge.net/projects/${MASTER_PN}"
SRC_URI="mirror://sourceforge/${MASTER_PN}/${PN}-1.3.0-11.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="1.3"

RDEPEND=">=net-zope/cmf-1.4.7"

ZPROD_LIST="generator"

src_install()
{
	zproduct_src_install all
}

pkg_postinst()
{
	zproduct_pkg_postinst
	ewarn "Please be warned that it should not be used together with dev-python/generator !"
}
