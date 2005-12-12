# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-3.5.0.ebuild,v 1.2 2005/12/12 19:19:56 josejx Exp $

KMNAME=kdesdk
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kioslaves from kdesdk package: the subversion kioslave"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="dev-util/subversion"


