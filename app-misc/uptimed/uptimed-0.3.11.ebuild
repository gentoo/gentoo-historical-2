# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/uptimed/uptimed-0.3.11.ebuild,v 1.1 2007/03/19 10:15:45 armin76 Exp $

inherit autotools

DESCRIPTION="System uptime record daemon that keeps track of your highest uptimes"
HOMEPAGE="http://podgorny.cz/uptimed/"
SRC_URI="http://podgorny.cz/uptimed/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# respect DESTDIR
	sed -i -e 's|-d \(/var/spool.*\)$|-d $(DESTDIR)\1|' Makefile.am || \
		die "sed failed"

	eautoreconf
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	keepdir /var/spool/uptimed
	dodoc ChangeLog README TODO AUTHORS CREDITS INSTALL.cgi sample-cgi/*
	doinitd "${FILESDIR}/uptimed" || die "failed to install init.d file"
}

pkg_postinst() {
	echo
	elog "Start uptimed with '/etc/init.d/uptimed start'"
	elog "To view your uptime records, use the command 'uprecords'."
	echo
}
