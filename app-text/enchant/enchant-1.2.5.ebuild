# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enchant/enchant-1.2.5.ebuild,v 1.15 2007/01/13 13:39:41 uberlord Exp $

inherit libtool

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="http://www.abisource.com/enchant/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
# FIXME : some sort of proper spellchecker selection needed

# The || is meant to make sure there is a a default spell lib to work with
# 25 Aug 2003; foser <foser@gentoo.org>

RDEPEND=">=dev-libs/glib-2
	|| ( virtual/aspell-dict app-text/ispell app-text/hspell app-text/hunspell )"

# libtool is needed for the install-sh to work
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize

	# Update the install-sh as the version shipped by upstream
	# will fail on FreeBSD systems
	cp /usr/share/libtool/install-sh "${S}"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README TODO
}
