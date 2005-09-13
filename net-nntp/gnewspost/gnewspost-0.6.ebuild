# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/gnewspost/gnewspost-0.6.ebuild,v 1.5 2005/09/13 20:14:46 metalgod Exp $

inherit eutils

DESCRIPTION="A graphical frontend for newspost, a binary news poster"
HOMEPAGE="http://www.vectorstar.net/~ash/gnewspost.html"
SRC_URI="http://www.vectorstar.net/~ash/files/${P}.tar.gz
	http://gentoo.mirror.at.stealer.net/files/${P}.tar.gz"
IUSE="nls"

LICENSE="BSD"
KEYWORDS="~amd64 ppc x86"
SLOT="0"

DEPEND="gnome-base/gnome-libs"

RDEPEND="${DEPEND}
	~net-nntp/newspost-2.0
	app-arch/cfv
	=sys-libs/db-1*"

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
	einstall icondir=${D}/usr/share/pixmaps || die "Installation failed"

	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING HACKING README TODO
}
