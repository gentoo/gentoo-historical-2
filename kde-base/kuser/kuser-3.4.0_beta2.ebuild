# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kuser/kuser-3.4.0_beta2.ebuild,v 1.1 2005/02/05 11:39:25 danarmak Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE user (/etc/passwd and other methods) manager"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

# TODO add NIS support