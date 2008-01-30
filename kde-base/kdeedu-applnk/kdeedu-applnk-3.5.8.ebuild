# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu-applnk/kdeedu-applnk-3.5.8.ebuild,v 1.5 2008/01/30 17:23:30 ranger Exp $
KMNAME=kdeedu
KMMODULE=applnk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="applnk files for kdeedu-derived apps"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""
