# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-3.4.1.ebuild,v 1.9 2005/09/13 13:51:19 agriffis Exp $

KMNAME=kdebase
MAXKDEVER=3.4.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

KMEXTRACTONLY="kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"
KMNODOCS=true