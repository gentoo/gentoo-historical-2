# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelirc/kdelirc-3.5.5.ebuild,v 1.4 2006/11/16 05:05:19 josejx Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDElirc - KDE Frontend to lirc"
KEYWORDS="~alpha amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="${RDEPEND}
	app-misc/lirc"
