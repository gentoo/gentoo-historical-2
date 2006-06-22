# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-kioslaves/kdepim-kioslaves-3.4.3.ebuild,v 1.9 2006/06/22 13:34:41 flameeyes Exp $

KMNAME=kdepim
KMMODULE=kioslaves

MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kioslaves from kdepim package"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="sasl"
DEPEND="sasl? ( >=dev-libs/cyrus-sasl-2 )
	$(deprange 3.4.1 $MAXKDEVER kde-base/libkmime)"

PATCHES="$FILESDIR/configure-fix-kdepim-sasl.patch"

KMCOPYLIB="libkmime libkmime/"
KMEXTRACTONLY="libkmime/"
KMCOMPILEONLY="libemailfunctions"

src_compile() {
	myconf="$myconf $(use_with sasl)"
	kde-meta_src_compile
}
