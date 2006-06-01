# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun/noatun-3.5.2.ebuild,v 1.12 2006/06/01 05:14:28 tcort Exp $

ARTS_REQUIRED="yes"
KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils flag-o-matic

DESCRIPTION="Noatun is a modular media player for KDE, featuring audio effects, a six-band graphic equalizer, a full plugin architecture and network transparency."
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)"

KMCOMPILEONLY="arts"

src_compile() {
	# fix bug 128884
	filter-flags -fomit-frame-pointer
	kde-meta_src_compile
}
