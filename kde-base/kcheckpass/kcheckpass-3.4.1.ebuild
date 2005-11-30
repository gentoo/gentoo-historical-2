# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcheckpass/kcheckpass-3.4.1.ebuild,v 1.1 2005/05/25 21:23:02 danarmak Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE pam client that allows you to auth as a specified user without actually doing anything as that user"
KEYWORDS="~x86 ~amd64"
IUSE="pam"
DEPEND="pam? ( sys-libs/pam ~kde-base/kdebase-pam-4 ) !pam? ( sys-apps/shadow )"

