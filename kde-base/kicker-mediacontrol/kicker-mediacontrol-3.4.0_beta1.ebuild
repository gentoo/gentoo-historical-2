# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kicker-mediacontrol/kicker-mediacontrol-3.4.0_beta1.ebuild,v 1.1 2005/01/15 02:24:33 danarmak Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kicker-applets/mediacontrol"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kicker plugin for controlling various media players"
KEYWORDS="~x86"
IUSE="xmms"
OLDDEPEND="~kde-base/kicker-$PV ~kde-base/kdeaddons-docs-kicker-applets-$PV
	xmms? ( media-sound/xmms )"
DEPEND="xmms? ( media-sound/xmms )
$(deprange-dual $PV $MAXKDEVER kde-base/kicker)
$(deprange-dual $PV $MAXKDEVER kde-base/kdeaddons-docs-kicker-applets)"

use xmms || export ac_cv_have_xmms=no


