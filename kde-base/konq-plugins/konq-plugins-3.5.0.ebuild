# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konq-plugins/konq-plugins-3.5.0.ebuild,v 1.3 2005/12/04 12:40:24 kloeri Exp $
KMNAME=kdeaddons
KMNODOCS=true
MAXKDEVER=$PV
inherit kde-meta

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/konqueror)"
RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"
