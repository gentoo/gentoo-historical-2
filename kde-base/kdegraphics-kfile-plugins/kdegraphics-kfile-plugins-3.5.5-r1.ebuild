# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics-kfile-plugins/kdegraphics-kfile-plugins-3.5.5-r1.ebuild,v 1.9 2008/02/19 04:20:29 ingmar Exp $

KMNAME=kdegraphics
KMMODULE=kfile-plugins
MAXKDEVER=3.5.8
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kfile plugins from kdegraphics"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="openexr"
DEPEND="media-libs/tiff
	openexr? ( media-libs/openexr )"

# compilation of the tiff plugin depends on the check in acinclude.m4.in,
# which doesn't have a switch.

# ps installed with kghostview, pdf installed with kpdf
KMEXTRACTONLY="kfile-plugins/ps kfile-plugins/pdf"

PATCHES="${FILESDIR}/post-3.5.5-kdegraphics.diff"

src_compile() {
	myconf="$myconf $(use_with openexr)"
	kde-meta_src_compile
}
