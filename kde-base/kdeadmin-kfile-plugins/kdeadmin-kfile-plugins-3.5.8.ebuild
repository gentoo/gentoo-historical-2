# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-kfile-plugins/kdeadmin-kfile-plugins-3.5.8.ebuild,v 1.7 2008/03/04 04:15:00 jer Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta
KMMODULE=kfile-plugins

DESCRIPTION="kfile plugins from kdeadmin"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
DEPEND=""
