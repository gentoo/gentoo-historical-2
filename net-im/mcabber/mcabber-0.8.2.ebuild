# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/mcabber/mcabber-0.8.2.ebuild,v 1.6 2007/05/06 11:45:59 genone Exp $

DESCRIPTION="A small Jabber console client with various features, like MUC and ssl"
HOMEPAGE="http://www.lilotux.net/~mikael/mcabber/"
SRC_URI="http://www.lilotux.net/~mikael/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~mips ppc sparc x86"

IUSE="ssl"

LANGS="pl fr"
# localized help versions are installed only, when LINGUAS var is set
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done;

DEPEND="ssl? ( >=dev-libs/openssl-0.9.7-r1 )
	>=dev-libs/glib-2.0.0
	sys-libs/ncurses"

src_compile() {
	econf \
		$(use_with ssl) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	# clean unneeded language documentation
	for i in ${LANGS}; do
		! use linguas_${i} && rm -rf ${D}/usr/share/${PN}/help/${i}
	done

	dodoc AUTHORS ChangeLog NEWS README TODO mcabberrc.example

	# install example themes
	insinto /usr/share/${PN}/themes
	doins ${S}/contrib/themes/*

	# contrib scripts
	newbin ${S}/contrib/eventcmd ${PN}_eventcmd
	newbin ${S}/contrib/cicq2mcabber.pl ${PN}_cicq2mcabber.pl
	newbin ${S}/contrib/mcwizz.pl ${PN}_mcwizz.pl
}

pkg_postinst() {
	elog
	elog "MCabber requires you to create a subdirectory .mcabber in your home"
	elog "directory and to to place there a configuration file."
	elog "A template of such file was installed as part of the documentation"
	elog "and you can find it here:"
	elog "${ROOT}usr/share/doc/${PF}/mcabberrc.example.gz"
	elog "Use gunzip tool to unzip it and edit before running MCabber"
	elog
	elog "As of MCabber version 0.8.2, there is also an wizzard script"
	elog "with which you can create all neccessery configuration tasks."
	elog "To start it simply run ${PN}_mcwizz.pl in console"
	elog
	elog "See the CONFIGURATION FILE and FILES sections of mcabber(1) for more information."
	elog
}
