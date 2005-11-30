# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdts/libdts-0.0.2-r3.ebuild,v 1.1 2005/08/26 19:14:51 eradicator Exp $

inherit eutils

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/dtsdec.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="oss debug"
RESTRICT="test"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	sys-devel/libtool
	=sys-devel/automake-1.7*
	>=sys-devel/autoconf-2.52d-r1"

src_unpack() {
	unpack ${A}
	if use ppc ; then
		# For some reason, ppc isn't properly using -fPIC... this
		# patch is broken, but makes it "work" on ppc.  If someone
		# will get me access, I'll fix it... --eradicator
		# Bug #98494
		epatch ${FILESDIR}/${P}-libtool2.patch
	else
		epatch ${FILESDIR}/${P}-libtool.patch
	fi
	epatch ${FILESDIR}/${P}-freebsd.patch

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
	dodoc AUTHORS ChangeLog NEWS README TODO doc/libdts.txt
}
