# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/mcabber/mcabber-0.9.0.ebuild,v 1.3 2007/05/06 11:45:59 genone Exp $

DESCRIPTION="A small Jabber console client with various features, like MUC, SSL, PGP"
HOMEPAGE="http://www.lilotux.net/~mikael/mcabber/"
SRC_URI="http://www.lilotux.net/~mikael/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="ssl crypt"

LANGS="pl fr"
# localized help versions are installed only, when LINGUAS var is set
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done;

DEPEND="ssl? ( >=dev-libs/openssl-0.9.7-r1 )
	crypt? ( >=app-crypt/gpgme-1.0.0 )
	>=dev-libs/glib-2.0.0
	sys-libs/ncurses"

src_compile() {
	econf \
		$(use_enable crypt gpgme) \
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
	dodoc doc/README_PGP.txt

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
	elog "directory and to place a configuration file there."
	elog "An example mcabberrc was installed as part of the documentation."
	elog "To create a new mcabberrc based on the example mcabberrc, execute the"
	elog "following commands:"
	elog
	elog "  mkdir -p ~/.mcabber"
	elog "  zcat ${ROOT}usr/share/doc/${PF}/mcabberrc.example.gz >~/.mcabber/mcabberrc"
	elog
	elog "Then edit ~/.mcabber/mcabberrc with your favorite editor."
	elog
	elog "As of MCabber version 0.8.2, there is also a wizard script"
	elog "with which you can create all necessary configuration options."
	elog "To use it, simply execute the following command:"
	elog
	elog "  ${PN}_mcwizz.pl"
	elog
	elog "See the CONFIGURATION FILE and FILES sections of the mcabber"
	elog "manual page (section 1) for more information."
	elog
	elog "From version 0.9.0 on, MCabber supports PGP encryption of messages."
	elog "See README_PGP.txt for details."
	elog
}
