# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/znc/znc-9999.ebuild,v 1.1 2011/09/14 08:32:02 wired Exp $

EAPI=3

PYTHON_DEPEND="python? 3"
inherit base git-2 python

DESCRIPTION="An advanced IRC Bouncer"
HOMEPAGE="http://znc.sourceforge.net"

EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/znc/znc.git"}
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ares debug extras ipv6 perl python ssl sasl tcl"

RDEPEND="
	ares? ( >=net-dns/c-ares-1.5 )
	perl? ( dev-lang/perl )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( >=dev-libs/openssl-0.9.7d )
	tcl? ( dev-lang/tcl )
"
DEPEND="
	dev-util/pkgconfig
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	${RDEPEND}
"

pkg_setup() {
	if use python; then
		python_set_active_version 3
		python_pkg_setup
	fi
}

src_prepare() {
	./autogen.sh
}

src_configure() {
	econf \
		$(use_enable ares c-ares) \
		$(use_enable debug) \
		$(use_enable extras extra) \
		$(use_enable ipv6) \
		$(use_enable perl) \
		$(use python && echo "--enable-python=python-$(python_get_version)") \
		$(use_enable sasl) \
		$(use_enable ssl openssl) \
		$(use_enable tcl tcl) \
		|| die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed."
	dodoc AUTHORS README.md || die "dodoc failed"
}

pkg_postinst() {
	elog
	elog "Run 'znc --makeconf' as the user you want to run ZNC as"
	elog "to make a configuration file"
	elog "If you are using SSL you should also run 'znc --makepem'"
	elog
}
