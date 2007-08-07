# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-magnatune/gmpc-magnatune-0.15.0.ebuild,v 1.6 2007/08/07 15:57:13 gustavoz Exp $

inherit eutils

DESCRIPTION="The plugin allows you to browse, and preview available albums on www.magnatune.com."
HOMEPAGE="http://sarine.nl/gmpc-plugins-lyrics-magnatune"
SRC_URI="http://download.sarine.nl/gmpc-${PV}/plugins/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc ~x86"
IUSE=""

DEPEND=">=media-sound/gmpc-${PV}
		dev-libs/libxml2"

pkg_setup() {
	if ! built_with_use =x11-libs/gtk+-2* jpeg ; then
		echo
		eerror "x11-libs/gtk+-2 needs to be built with \"jpeg\" USE flag"
		die "x11-libs/gtk+-2 needs to be built with \"jpeg\" USE flag"
	fi
}

src_compile ()
{
	econf || die
	emake || die
}

src_install ()
{
	make DESTDIR="${D}" install || die
}
