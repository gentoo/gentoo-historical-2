# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-3.4.0_beta2.ebuild,v 1.1 2005/02/05 11:39:24 danarmak Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="~x86"
IUSE=""

KMEXTRACTONLY="kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"
KMNODOCS=true