# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kgpg/kgpg-3.5_beta1.ebuild,v 1.2 2005/10/08 21:47:15 betelgeuse Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE gpg keyring manager"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$DEPEND
	app-crypt/gnupg"
