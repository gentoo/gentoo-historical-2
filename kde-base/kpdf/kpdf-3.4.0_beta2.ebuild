# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpdf/kpdf-3.4.0_beta2.ebuild,v 1.2 2005/02/05 18:56:40 danarmak Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kpdf, a kde pdf viewer based on xpdf"
KEYWORDS="~x86"
IUSE=""
KMEXTRA="kfile-plugins/pdf"

DEPEND=">=media-libs/freetype-2.0.5 media-libs/t1lib"

src_unpack(){
	kde-meta_src_unpack
	epatch ${FILESDIR}/CAN-2005-0064_kde-3.4.patch
}
