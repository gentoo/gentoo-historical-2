# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hteditor/hteditor-0.9.4.ebuild,v 1.1 2006/10/29 08:50:30 dragonheart Exp $

inherit eutils autotools

DESCRIPTION="editor for executable files"
HOMEPAGE="http://hte.sourceforge.net/"
SRC_URI="mirror://sourceforge/hte/ht-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/libc
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.4
	sys-devel/autoconf
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/ht-${PV}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
	eautoreconf
}


src_compile() {
	econf || die
	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS KNOWNBUGS TODO README
	dohtml doc/ht.html
	doinfo doc/*.info
}
