# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konq-plugins/konq-plugins-3.4.0_rc1-r1.ebuild,v 1.1 2005/02/28 17:49:36 danarmak Exp $
KMNAME=kdeaddons
MAXKDEVER=$PV
inherit kde-meta

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="~x86"
IUSE=""
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/konqueror)
$(deprange 3.4.0_beta2 $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"
