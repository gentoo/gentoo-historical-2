# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/uptimed/uptimed-0.3.16-r4.ebuild,v 1.1 2009/03/27 10:54:15 armin76 Exp $

inherit autotools

DESCRIPTION="System uptime record daemon that keeps track of your highest uptimes"
HOMEPAGE="http://podgorny.cz/uptimed"
SRC_URI="http://podgorny.cz/uptimed/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

pkg_setup() {
	enewgroup uptimed
	enewuser uptimed -1 -1 -1 uptimed
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# respect DESTDIR
	sed -i -e 's|-d \(/var/spool.*\)$|-d $(DESTDIR)\1|' Makefile.am || \
		die "sed failed."

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	diropts -o uptimed -g uptimed
	dodir /var/run/uptimed
	keepdir /var/spool/uptimed
	fowners uptimed:uptimed /var/spool/uptimed
	dodoc ChangeLog README TODO AUTHORS CREDITS INSTALL.cgi sample-cgi/*
	newinitd "${FILESDIR}"/uptimed.init uptimed
}

pkg_postinst() {
	einfo "Fixing permissions in /var/spool/${PN}"
	chown -R uptimed:uptimed /var/spool/${PN}
	echo
	elog "Start uptimed with '/etc/init.d/uptimed start'"
	elog "To view your uptime records, use the command 'uprecords'."
	echo
}
