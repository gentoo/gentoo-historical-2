# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-misc-ethiopic/font-misc-ethiopic-1.0.0.ebuild,v 1.18 2009/09/30 19:13:19 ssuominen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

FONT_DIR="TTF OTF"

inherit x-modular

DESCRIPTION="Miscellaneous Ethiopic fonts"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ~ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf
	>=media-fonts/font-util-0.99.2"

CONFIGURE_OPTIONS="--with-mapfiles=${XDIR}/share/fonts/util
	--with-ttf-fontdir=/usr/share/fonts/TTF
	--with-otf-fontdir=/usr/share/fonts/OTF"
