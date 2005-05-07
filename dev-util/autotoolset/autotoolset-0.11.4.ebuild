# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/autotoolset/autotoolset-0.11.4.ebuild,v 1.3 2005/05/07 09:36:10 dholm Exp $

inherit eutils

DESCRIPTION="colection of small tools to simplify project development with autotools"
HOMEPAGE="http://autotoolset.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/libc
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	app-arch/sharutils
	app-arch/gzip
	dev-lang/perl"

src_test() {
	emake check || die "test failed"
}

src_install() {
	make install DESTDIR="${D}" || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
