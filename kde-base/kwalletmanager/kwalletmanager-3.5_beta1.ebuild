# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwalletmanager/kwalletmanager-3.5_beta1.ebuild,v 1.3 2005/10/22 07:40:31 halcy0n Exp $

KMNAME=kdeutils
KMMODULE=kwallet
MAXKDEVER=3.5.0_beta2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE Wallet Management Tool"
KEYWORDS="~amd64 ~x86"
IUSE=""