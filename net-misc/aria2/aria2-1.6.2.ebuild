# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/aria2/aria2-1.6.2.ebuild,v 1.1 2009/10/11 09:15:38 dev-zero Exp $

EAPI="2"

DESCRIPTION="A download utility with resuming and segmented downloading with HTTP/HTTPS/FTP/BitTorrent support."
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="ares bittorrent expat gnutls metalink nls sqlite ssl test"

CDEPEND="sys-libs/zlib
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.2.9 )
		!gnutls? ( dev-libs/openssl ) )
	ares? ( >=net-dns/c-ares-1.5.0 )
	bittorrent? (
		gnutls? ( >=net-libs/gnutls-1.2.9 >=dev-libs/libgcrypt-1.2.2 )
		!gnutls? ( dev-libs/openssl ) )
	metalink? (
		!expat? ( >=dev-libs/libxml2-2.6.26 )
		expat? ( dev-libs/expat )
	)
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.12.0 )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libiconv virtual/libintl )"

src_prepare() {
	sed -i -e "s|/tmp|${T}|" test/*.cc test/*.txt || die "sed failed"
}

src_configure() {
	local myconf="--without-gnutls --without-openssl"
	use ssl && \
		myconf="$(use_with gnutls) $(use_with !gnutls openssl)"

	# Note:
	# - depends on libgcrypt only when using gnutls
	# - links only against libxml2 and libexpat when metalink is enabled
	# - always enable gzip/http compression since zlib should always be available anyway
	# - always enable epoll since we can assume kernel 2.6.x
	# - other options for threads: solaris, pth, win32
	econf \
		--enable-epoll \
		--enable-threads=posix \
		--with-libz \
		$(use_enable nls) \
		$(use_enable metalink) \
		$(use_with expat libexpat) \
		$(use_with !expat libxml2) \
		$(use_with sqlite sqlite3) \
		$(use_enable bittorrent) \
		$(use_with ares libcares) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm -rf "${D}/usr/share/doc/aria2"
	dodoc ChangeLog README AUTHORS NEWS
	dohtml README.html doc/aria2c.1.html
}
