# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtu-svn/libtu-svn-20040412.ebuild,v 1.3 2004/06/24 23:25:06 agriffis Exp $

inherit subversion

DESCRIPTION="A small utility library for programs written in C"
HOMEPAGE="http://modeemi.fi/~tuomov/ion/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"
IUSE=""
DEPEND="virtual/glibc"

ESVN_REPO_URI="http://tao.uab.es/ion/svn/libtu/trunk"
ESVN_PROJECT="libtu-snapshot"

src_compile() {

	sed -i ${S}/system.mk \
		-e 's:^\(PREFIX=\)/usr/local/:\1/usr:' \
		-e "s:^\(CFLAGS=\)-g -Os :\1${CFLAGS} :"

	emake || die

}

src_install() {

	dolib libtu.a
	insinto /usr/include/libtu
	doins *.h
	dodoc README README.rb

}
