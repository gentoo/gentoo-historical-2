# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdc1394/libdc1394-2.0.0_pre4.ebuild,v 1.4 2005/09/12 15:43:41 agriffis Exp $

inherit eutils

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="libdc1394 is a library that is intended to provide a high level programming interface for application developers who wish to control IEEE 1394 based cameras that conform to the 1394-based Digital Camera Specification (found at http://www.1394ta.org/)"
HOMEPAGE="http://sourceforge.net/projects/libdc1394/"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	http://dev.gentoo.org/~seemant/distfiles/${P}-svn-fixes.patch.bz2
	mirror://gentoo/${P}-svn-fixes.patch.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc ~x86"
IUSE="X"

DEPEND=">=sys-libs/libraw1394-0.9.0
	sys-devel/libtool
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A} ; cd ${S}
	epatch ${DISTDIR}/${P}-svn-fixes.patch.bz2

	if ! use X; then
		epatch ${FILESDIR}/nox11.patch
	fi

}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS README AUTHORS ChangeLog
}
