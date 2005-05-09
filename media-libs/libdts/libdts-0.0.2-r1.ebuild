# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdts/libdts-0.0.2-r1.ebuild,v 1.5 2005/05/09 00:52:13 agriffis Exp $

inherit eutils

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/dtsdec.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ia64 ppc ~ppc64 ~sparc ~x86"
IUSE="oss debug"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	sys-devel/libtool
	=sys-devel/automake-1.7*
	>=sys-devel/autoconf-2.52d-r1"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-libtool.patch

	cd ${S}

	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5

	libtoolize --force --copy || die "libtoolize --force --copy failed"
	aclocal || die "aclocal failed"
	autoheader || die "autoheader failed"
	automake --gnu --add-missing --include-deps --force-missing --copy || die "automake failed"
	autoconf || die "autoconf failed"
}

src_compile() {
	econf $(use_enable oss) $(use_enable debug)
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO doc/libdts.txt
}

src_test() { :; }
