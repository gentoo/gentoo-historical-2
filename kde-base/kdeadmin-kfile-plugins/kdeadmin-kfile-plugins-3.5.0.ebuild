# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-kfile-plugins/kdeadmin-kfile-plugins-3.5.0.ebuild,v 1.6 2006/03/27 21:54:35 agriffis Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta
KMMODULE=kfile-plugins

DESCRIPTION="kfile plugins from kdeadmin"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

