# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/pager/pager-1.0.1.ebuild,v 1.3 2006/01/18 20:32:26 vanquirius Exp $

inherit rox eutils

PAGER_PATCH_FN="01_all_libwnck-2-fix.patch"
DESCRIPTION="Pager - A pager applet for ROX-Filer"
HOMEPAGE="http://rox.sourceforge.net/"
SRC_URI="mirror://sourceforge/rox/${P}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=x11-libs/libwnck-2.4.0
		>=dev-libs/libxml2-2.0"

ROX_LIB_VER=1.9.14
APPNAME=Pager
SET_PERM=true

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"/${P}/${APPNAME}/src
	epatch "${FILESDIR}"/${PAGER_PATCH_FN}
}
