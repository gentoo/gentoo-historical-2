# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konq-plugins/konq-plugins-3.5.5.ebuild,v 1.2 2006/11/13 11:37:28 opfer Exp $

KMNAME=kdeaddons
KMNODOCS=true
MAXKDEVER=$PV
inherit kde-meta

DESCRIPTION="Various plugins for Konqueror."
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/konqueror)
	!kde-misc/metabar"
RDEPEND="${DEPEND}
$(deprange 3.5.4 $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"
