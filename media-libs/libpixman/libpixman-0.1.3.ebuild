# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpixman/libpixman-0.1.3.ebuild,v 1.7 2006/11/04 11:26:47 vapier Exp $

DESCRIPTION="A generic library for manipulating pixel regions"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ppc64 s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make install DESTDIR=${D} || die
}
