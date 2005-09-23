# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/urwvn-fonts/urwvn-fonts-2.0.ebuild,v 1.5 2005/09/23 15:50:25 gustavoz Exp $

inherit font

MY_PF=${PF/-fonts/}
DESCRIPTION="free good quality fonts gpl'd by Han The Thanh, based on URW++ fonts"
HOMEPAGE="http://vntex.sourceforge.net/urwvn/"
SRC_URI="http://vntex.sourceforge.net/urwvn/${MY_PF}-type1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 sparc"
IUSE=""

S=${WORKDIR}/type1
FONT_SUFFIX="pfa afm"
FONT_S=${S}
