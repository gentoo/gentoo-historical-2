# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-misc-ethiopic/font-misc-ethiopic-1.0.1-r1.ebuild,v 1.9 2010/10/21 01:00:32 ranger Exp $

FONT_DIR="OTF"

EAPI=3
inherit xorg-2

DESCRIPTION="Miscellaneous Ethiopic fonts"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"

FONT_OPTIONS="--with-otf-fontdir=${EPREFIX}usr/share/fonts/OTF"

src_install() {
	xorg-2_src_install
	# TTF fonts are not supposed to be installed.
	# Also fixes file collision per bug #309689
	rm -rf "${D}/${EPREFIX}usr/share/fonts/TTF"
}
