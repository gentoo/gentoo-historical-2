# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/komics/komics-1.2.ebuild,v 1.4 2004/04/12 22:27:17 centic Exp $

inherit kde-base

need-kde 3

DESCRIPTION="Komics - a KDE panel applet for fetching comics strips from web."
HOMEPAGE="http://www.orson.it/~domine/komics/"
SRC_URI="http://www.orson.it/~domine/komics/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

KEYWORDS="~x86 ~amd64 ~ppc"

S=${WORKDIR}/komics

newdepend "dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/HTML-Tagset"

src_unpack() {
	kde_src_unpack
	rm -rf ${S}/autom4te.cache
}

src_compile() {
	local myconf="`use_enable arts`"
	kde_src_compile all
}
