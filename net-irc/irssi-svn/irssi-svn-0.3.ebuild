# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi-svn/irssi-svn-0.3.ebuild,v 1.1 2005/05/14 23:09:36 swegener Exp $

inherit subversion perl-module

ESVN_REPO_URI="http://svn.irssi.org/repos/irssi/trunk/"
ESVN_PROJECT="irssi"
ESVN_BOOTSTRAP="./autogen.sh"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ipv6 perl ssl"

RDEPEND=">=dev-libs/glib-2.2.1
	sys-libs/ncurses
	perl? ( dev-lang/perl )
	!net-irc/irssi
	!net-irc/irssi-cvs"
DEPEND="${RDEPEND}
	www-client/lynx
	nls? ( sys-devel/gettext )
	>=sys-devel/autoconf-2.58"

src_compile() {
	export WANT_AUTOCONF=2.5

	econf \
		--with-glib2 \
		--with-proxy \
		--with-ncurses \
		$(use_with perl) \
		$(use_enable ipv6) \
		$(use_enable ssl) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	if use perl
	then
		for dir in "${S}"/src/perl/{common,irc,textui,ui}
		do
			cd "${dir}"
			perl-module_src_prep
		done
		cd "${S}"
	fi

	make \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		gnulocaledir="${D}"/usr/share/locale \
		install || die "make install failed"

	prepalldocs
	dodoc AUTHORS ChangeLog README TODO NEWS
	dohtml -r "${S}"/docs/. || die "dohtml failed"
}
