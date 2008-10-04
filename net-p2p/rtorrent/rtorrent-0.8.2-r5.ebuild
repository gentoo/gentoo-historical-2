# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.2-r5.ebuild,v 1.8 2008/10/04 22:40:48 loki_val Exp $

inherit eutils autotools toolchain-funcs flag-o-matic

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug ipv6 xmlrpc"

RDEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2
	>=net-misc/curl-7.18
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.8.0+gcc-4.3.patch
	epatch "${FILESDIR}"/${P}-fix_start_stop_filter.patch
	epatch "${FILESDIR}"/${P}-fix_conn_type_seed.patch
	epatch "${FILESDIR}"/${P}-fix_load_cache.patch
	epatch "${FILESDIR}"/${P}-fix_utf8_filenames.patch
	epatch "${FILESDIR}"/${P}-fix-configure-execinfo.patch
	epatch "${FILESDIR}"/${P}-gcc34.patch
	epatch "${FILESDIR}"/${P}-fix_scgi_crash.patch
	eautoreconf
}

src_compile() {
	replace-flags -Os -O2
	append-flags -fno-strict-aliasing

	if [[ $(tc-arch) = "x86" ]]; then
		filter-flags -fomit-frame-pointer -fforce-addr
	fi

	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO doc/rtorrent.rc
}

pkg_postinst() {
	elog "rtorrent now supports a configuration file."
	elog "A sample configuration file for rtorrent can be found"
	elog "in ${ROOT}usr/share/doc/${PF}/rtorrent.rc.gz."
	elog ""
	ewarn "If you're upgrading from rtorrent <0.8.0, you will have to delete your"
	ewarn "session directory or run the fixSession080-c.py script from this address:"
	ewarn "http://rssdler.googlecode.com/files/fixSession080-c.py"
	ewarn "See http://libtorrent.rakshasa.no/wiki/LibTorrentKnownIssues for more info."
}
