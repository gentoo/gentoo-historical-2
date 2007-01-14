# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_layout/mod_layout-4.0.1a-r1.ebuild,v 1.7 2007/01/14 17:02:49 chtekk Exp $

inherit apache-module

KEYWORDS="~amd64 ppc x86"

DESCRIPTION="An Apache2 module for adding custom headers and/or footers."
HOMEPAGE="http://software.tangent.org/"
SRC_URI="http://download.tangent.org/${P}.tar.gz"
LICENSE="as-is"
SLOT="2"
IUSE=""

DEPEND=""
RDEPEND=""

APXS2_ARGS="-c ${PN}.c utility.c layout.c"

APACHE2_MOD_CONF="15_mod_layout"
APACHE2_MOD_DEFINE="LAYOUT"

DOCFILES="README"

need_apache2
