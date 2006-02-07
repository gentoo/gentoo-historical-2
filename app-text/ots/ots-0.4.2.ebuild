# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ots/ots-0.4.2.ebuild,v 1.7 2006/02/07 05:34:53 agriffis Exp $

inherit eutils

DESCRIPTION="Open source Text Summarizer, as used in newer releases of abiword and kword."
HOMEPAGE="http://libots.sourceforge.net/"
SRC_URI="mirror://sourceforge/libots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ~sparc x86"
IUSE=""

RDEPEND="=dev-libs/glib-2*
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/popt-1.5"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}; cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.diff
}

src_compile() {
	# bug 97448
	econf --disable-gtk-doc || die
	# parallel make fails, bug 112932
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	rm -rf "${D}"/usr/share/doc/libots
	dodoc AUTHORS BUGS ChangeLog HACKING NEWS README TODO
	cd "${S}"/doc/html
	dohtml -r ./
}
