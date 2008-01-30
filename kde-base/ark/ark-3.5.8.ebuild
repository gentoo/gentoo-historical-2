# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ark/ark-3.5.8.ebuild,v 1.5 2008/01/30 17:23:58 ranger Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Archiving tool"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

pkg_postinst(){
	kde_pkg_postinst
	elog "You may want to install app-arch/lha, app-arch/p7zip, app-arch/rar, app-arch/zip"
	elog "or app-arch/zoo for support of these archive types."
}
