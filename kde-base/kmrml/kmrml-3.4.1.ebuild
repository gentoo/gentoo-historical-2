# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmrml/kmrml-3.4.1.ebuild,v 1.1.1.1 2005/11/30 10:13:06 chriswhite Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KIO and konqueror plugins for MRML - an image indexing service"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""