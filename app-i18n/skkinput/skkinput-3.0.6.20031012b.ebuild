# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skkinput/skkinput-3.0.6.20031012b.ebuild,v 1.3 2004/06/24 21:54:44 agriffis Exp $

inherit eutils

IUSE=""

MY_P="${PN}${PV%%.*}-snap${PV##*.}"

DESCRIPTION="A SKK-like Japanese input method for X11"
HOMEPAGE="http://www.tatari-sakamoto.jp/~tatari/skkinput3.jis.html"
SRC_URI="http://member.nifty.ne.jp/Tatari_SAKAMOTO/arc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
# skkinput-3 branch is alpha release and shouldn't be marked as stable
KEYWORDS="~x86 ~ppc ~sparc alpha"

DEPEND="virtual/glibc
	virtual/x11"

RDEPEND="${DEPEND}
	virtual/skkserv"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P%.*}-gentoo.diff
}

src_compile() {
	xmkmf -a || die
	make || die
}

src_install () {
	einstall DESTDIR=${D} || die

	dodoc ChangeLog *.jis

	insinto /etc/skel
	newins dot.skkinput .skkinput.el
}
