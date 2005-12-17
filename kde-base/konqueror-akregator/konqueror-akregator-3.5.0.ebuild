# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror-akregator/konqueror-akregator-3.5.0.ebuild,v 1.5 2005/12/17 09:46:11 corsair Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="konq-plugins/akregator"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="konqueror's akregator plugin"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/konqueror)"
RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)
$(deprange-dual $PV $MAXKDEVER kde-base/akregator)"
