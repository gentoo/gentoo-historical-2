# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact-specialdates/kontact-specialdates-3.5_beta1.ebuild,v 1.1 2005/09/22 19:57:54 flameeyes Exp $

KMNAME=kdepim
KMNOMODULE=true
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Special Dates plugin for Kontact: displays a summary of important holidays and calendar events"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/kontact)
$(deprange $PV $MAXKDEVER kde-base/kaddressbook)
$(deprange $PV $MAXKDEVER kde-base/korganizer)
$(deprange $PV $MAXKDEVER kde-base/libkholidays)"
RDEPEND="$DEPEND
$(deprange $PV $MAXKDEVER kde-base/kmail)" # only to enable send mail functionality

KMCOPYLIB="libkdepim libkdepim/
	libkpinterfaces kontact/interfaces
	libkaddressbook kaddressbook
	libkorganizer_calendar korganizer
	libkholidays libkholidays"
KMEXTRACTONLY="libkholidays
	kontact/interfaces/
	kaddressbook
	korganizer
	libkdepim"
KMEXTRA="kontact/plugins/specialdates"
