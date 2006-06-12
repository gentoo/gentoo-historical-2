# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/emech/emech-3.0.2.ebuild,v 1.1 2006/06/12 00:48:44 antarus Exp $

inherit toolchain-funcs

DESCRIPTION="The EnergyMech is a UNIX compatible IRC bot programmed in the C language"
HOMEPAGE="http://www.energymech.net/"
SRC_URI="http://www.energymech.net/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="debug session tcltk"

DEPEND=""

src_unpack() {
	unpack ${A}

	sed -i \
		-e 's: "help/":"/usr/share/energymech/help/":' \
		-e 's: "messages/":"/usr/share/energymech/messages/":' \
		"${S}"/src/config.h.in
}

src_compile() {
	./configure \
		--with-alias \
		--with-botnet \
		--with-bounce \
		--with-ctcp \
		--with-dccfile \
		--with-dynamode \
		--with-dyncmd \
		--with-greet \
		--with-ircd_ext \
		--with-md5 \
		--with-newbie \
		--with-note \
		--with-notify \
		--with-rawdns \
		--with-redirect \
		--with-seen \
		--with-stats \
		--with-telnet \
		--with-toybox \
		--with-trivia \
		--with-uptime \
		--with-web \
		--with-wingate \
		--without-profiling \
		$(use_with tcltk tcl) \
		$(use_with session) \
		$(use_with debug) \
		|| die "./configure failed"
	emake -C src CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin src/energymech || die "dobin failed"

	insinto /usr/share/energymech/help
	doins help/* || die "doins failed"

	insinto /usr/share/energymech/messages
	doins messages/*.txt || die "doins failed"

	dodoc sample.* README* TODO VERSIONS CREDITS checkmech || die "dodoc failed"
}

pkg_postinst() {
	einfo
	einfo "You can find a sample config file at"
	einfo "/usr/share/doc/${PF}/sample.conf.gz"
	einfo
}
