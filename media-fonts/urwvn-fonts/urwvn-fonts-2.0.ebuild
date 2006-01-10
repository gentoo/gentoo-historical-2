# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/urwvn-fonts/urwvn-fonts-2.0.ebuild,v 1.6 2006/01/10 18:45:36 hansmi Exp $

inherit font

MY_PF=${PF/-fonts/}
DESCRIPTION="free good quality fonts gpl'd by Han The Thanh, based on URW++ fonts"
HOMEPAGE="http://vntex.sourceforge.net/urwvn/"
SRC_URI="http://vntex.sourceforge.net/urwvn/${MY_PF}-type1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/type1
FONT_SUFFIX="pfa afm"
FONT_S=${S}
