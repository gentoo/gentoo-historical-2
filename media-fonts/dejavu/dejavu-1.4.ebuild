# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/dejavu/dejavu-1.4.ebuild,v 1.1 2004/10/17 07:16:22 usata Exp $

inherit font

MY_P="${P/dejavu/dejavu-ttf}"

DESCRIPTION="DejaVu fonts, bitstream vera with ISO-8859-2 characters"
HOMEPAGE="http://dejavu.sourceforge.net/"
LICENSE="BitstreamVera"
SRC_URI="mirror://sourceforge/dejavu/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

# DEPEND and IUSE is defined in font.eclass
#DEPEND="X? ( virtual/x11 )"

DOCS="AUTHORS BUGS LICENSE NEWS README status.txt"
FONT_SUFFIX="ttf"
S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
