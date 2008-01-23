# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/urwvn-fonts/urwvn-fonts-3.04.ebuild,v 1.3 2008/01/23 18:37:00 armin76 Exp $

inherit font

MY_P=${P/_/-}
MY_P=${MY_P/-fonts/}
DESCRIPTION="free good quality fonts gpl'd by Han The Thanh, based on URW++ fonts"
HOMEPAGE="http://vntex.org/urwvn/"
SRC_URI="http://vntex.org/urwvn/download/${MY_P}-ttf.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}-ttf"
FONT_SUFFIX="ttf"
FONT_S=${S}

DEPEND="app-arch/unzip"
