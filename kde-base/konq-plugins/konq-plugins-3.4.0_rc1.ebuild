# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konq-plugins/konq-plugins-3.4.0_rc1.ebuild,v 1.1 2005/02/27 20:21:38 danarmak Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="konq-plugins/arkplugin"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Ark (kde archiver) plugin for konqueror"
KEYWORDS="~x86"
IUSE=""
OLDDEPEND="~kde-base/konqueror-$PV ~kde-base/kdeaddons-docs-konq-plugins-3.3.1"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/konqueror)
$(deprange 3.4.0_beta2 $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"
