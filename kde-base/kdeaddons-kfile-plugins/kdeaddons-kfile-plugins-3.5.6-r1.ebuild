# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons-kfile-plugins/kdeaddons-kfile-plugins-3.5.6-r1.ebuild,v 1.1 2007/04/30 20:24:54 carlo Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kfile-plugins/"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kdeaddons kfile plugins"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND="dev-libs/openssl"

src_compile() {
	myconf="--with-ssl"
	kde_src_compile
}

