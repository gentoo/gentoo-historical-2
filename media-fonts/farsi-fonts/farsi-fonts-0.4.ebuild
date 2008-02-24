# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/farsi-fonts/farsi-fonts-0.4.ebuild,v 1.8 2008/02/24 12:02:22 armin76 Exp $

inherit font

S=${WORKDIR}/${P/-/}

DESCRIPTION="Farsi (Persian) TrueType fonts"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Khotot"
SRC_URI="mirror://sourceforge/arabeyes/${P//-/_}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~ppc s390 sh ~sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}"

DOCS="NEWS.txt"
