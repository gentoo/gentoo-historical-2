# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-kioslaves/kdepim-kioslaves-3.4.3.ebuild,v 1.4 2005/11/25 11:18:55 cryos Exp $

KMNAME=kdepim
KMMODULE=kioslaves

MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kioslaves from kdepim package"
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc ~x86"
IUSE="sasl"
DEPEND="sasl? ( >=dev-libs/cyrus-sasl-2 )
	$(deprange 3.4.1 $MAXKDEVER kde-base/libkmime)"

PATCHES="$FILESDIR/configure-fix-kdepim-sasl.patch"
myconf="$myconf $(use_with sasl)"

KMCOPYLIB="libkmime libkmime/"
KMEXTRACTONLY="libkmime/"
KMCOMPILEONLY="libemailfunctions"

