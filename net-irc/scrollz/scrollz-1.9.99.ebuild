# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/scrollz/scrollz-1.9.99.ebuild,v 1.2 2007/04/14 15:25:12 armin76 Exp $

inherit eutils

MY_P=ScrollZ-${PV}

DESCRIPTION="Advanced IRC client based on ircII"
SRC_URI="http://www.scrollz.com/${MY_P}.tar.bz2"
HOMEPAGE="http://www.scrollz.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc ~ppc-macos x86"
IUSE="ipv6 socks5 ssl"

DEPEND="ssl? ( net-libs/gnutls )"
S="${WORKDIR}"/${MY_P}

src_compile() {
	if use ssl; then
		myconf="--with-ssl"
	fi

	econf \
		--with-default-server=irc.freenode.net \
		$(use_enable ipv6) \
		$(use_enable socks5) \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/share/man/man1
	einstall \
		sharedir="${D}"/usr/share \
		mandir="${D}"/usr/share/man/man1 \
		install \
		|| die "einstall failed"

	dodoc ChangeLog* README* || die "dodoc failed"

	# fix perms of manpage
	fperms 644 /usr/share/man/man1/scrollz.1
}
