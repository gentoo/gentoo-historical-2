# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Arcady Genkin <agenkin@thpoon.com>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wmnetselect/wmnetselect-0.8-r1.ebuild,v 1.2 2002/07/08 21:31:07 aliz Exp $

S=${WORKDIR}/${P}

DESCRIPTION="WindowMaker browser launcher doclette"
HOMEPAGE="http://freshmeat.net/projects/wmnetselect/"

# Technically, the URL is http://home.att.net/~apathos/code/${P}.tar.gz,
# but it's dead. :^(
SRC_URI="ftp://ftp11.freebsd.org/pub/FreeBSD/ports/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86

DEPEND="x11-base/xfree virtual/glibc"

src_compile() {
        xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS}" wmnetselect || die
}

src_install () {
        dobin   wmnetselect
        dodoc   COPYING README ChangeLog TODO README.html
}
