# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcheckpass/kcheckpass-3.4.0.ebuild,v 1.3 2005/03/21 03:26:13 weeve Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE pam client that allows you to auth as a specified user without actually doing anything as that user"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="pam"
DEPEND="pam? ( sys-libs/pam ~kde-base/kdebase-pam-4 ) !pam? ( sys-apps/shadow )"

