# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-0.8.10-r3.ebuild,v 1.4 2006/06/25 13:25:04 dertobi123 Exp $

inherit perl-app eutils flag-o-matic

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
SRC_URI="http://irssi.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="ipv6 perl ssl socks5"

RDEPEND="!net-irc/irssi-svn
	>=dev-libs/glib-2.2.1
	sys-libs/ncurses
	ssl? ( dev-libs/openssl )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-dcc-segv.patch
}

src_compile() {
	# Irssi uses extern inlines and that needs at least -O
	is-flag "-O*" || append-flags -O

	econf \
		--with-proxy \
		--with-ncurses \
		--with-perl-lib=vendor \
		$(use_enable ssl) \
		$(use_with perl) \
		$(use_enable ipv6) \
		$(use_with socks5 socks) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	if use perl
	then
		for dir in "${S}"/src/perl/{common,irc,textui,ui}
		do
			cd "${dir}"
			perl-app_src_prep
		done
		cd "${S}"
	fi

	make \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		gnulocaledir="${D}"/usr/share/locale \
		install || die "make install failed"

	use perl && fixlocalpod

	dodoc AUTHORS ChangeLog README TODO NEWS || die "dodoc failed"
	dohtml -r "${S}"/docs/. || die "dohtml failed"
}
