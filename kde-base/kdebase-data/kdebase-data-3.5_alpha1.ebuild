# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-data/kdebase-data-3.5_alpha1.ebuild,v 1.1 2005/09/07 11:16:09 flameeyes Exp $

KMNAME=kdebase
KMNOMODULE=true
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Icons, localization data and various .desktop files from kdebase. Includes the l10n, pics and applnk subdirs."
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
!kde-base/kdebase-l10n !kde-base/kdebase-applnk !kde-base/kdebase-pics" # replaced these three ebuilds

KMEXTRA="l10n pics applnk"

