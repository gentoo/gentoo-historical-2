# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-3.4.1.ebuild,v 1.2 2005/05/26 17:14:29 danarmak Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: A dialer and front-end to pppd"
KEYWORDS="~x86 ~amd64 ~ppc64 ~ppc ~sparc"
IUSE=""