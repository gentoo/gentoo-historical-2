# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmix/kmix-3.5.0.ebuild,v 1.5 2005/12/17 13:45:37 corsair Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="aRts mixer gui"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa"
DEPEND="alsa? ( media-libs/alsa-lib )"
KMEXTRACTONLY="kscd/configure.in.in"

src_compile() {
	# alsa 0.9 not supported
	use alsa && myconf="$myconf --with-alsa --with-arts-alsa" || myconf="$myconf --without-alsa --disable-alsa"

	kde-meta_src_compile
}