# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/gnewspost/gnewspost-0.6.ebuild,v 1.4 2003/08/14 20:02:19 lisa Exp $

DESCRIPTION="A graphical frontend for newspost, a binary news poster"
HOMEPAGE="http://www.vectorstar.net/~ash/gnewspost.html"
SRC_URI="http://www.vectorstar.net/~ash/files/${P}.tar.gz"
IUSE="nls"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"

DEPEND="gnome-base/gnome-libs"

RDEPEND="${DEPEND}
	=net-news/newspost-2.0
	app-arch/cfv"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/session.c-fix_errno.patch.gz
}

src_compile() {
	local myconf=""

	use nls \
		&& myconf="--with-included-gettext" \
		|| myconf="--disable-nls"
	
	econf $myconf || die "./configure failed"
	
	emake || die "Compilation failed"
}

src_install () {
	einstall \
		icondir=${D}/usr/share/pixmaps || die "Installation failed"

	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING HACKING README TODO
}
