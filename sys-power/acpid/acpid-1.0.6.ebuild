# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpid/acpid-1.0.6.ebuild,v 1.1 2007/07/17 19:42:55 genstef Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Daemon for Advanced Configuration and Power Interface"
HOMEPAGE="http://acpid.sourceforge.net"
SRC_URI="mirror://sourceforge/acpid/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 -ppc ~x86"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=""

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-examples.diff
}

src_compile() {
	# DO NOT COMPILE WITH OPTIMISATIONS (bug #22365)
	# That is a note to the devs.  IF you are a user, go ahead and optimise
	# if you want, but we won't support bugs associated with that.
	emake CC="$(tc-getCC)" INSTPREFIX="${D}" || die "emake failed"
}

src_install() {
	emake INSTPREFIX="${D}" install || die "emake install failed"

	exeinto /etc/acpi
	doexe examples/default.sh
	insinto /etc/acpi/events
	doins examples/default

	dodoc README Changelog TODO

	newinitd ${FILESDIR}/${P}-init.d acpid
	newconfd ${FILESDIR}/${P}-conf.d acpid

	docinto examples
	dodoc samples/{acpi_handler.sh,sample.conf}
	dodoc examples/ac{,.sh}

	docinto examples/battery
	dodoc samples/battery/*

	docinto examples/panasonic
	dodoc samples/panasonic/*
}

pkg_postinst() {
	echo
	einfo "You may wish to read the Gentoo Linux Power Management Guide,"
	einfo "which can be found online at:"
	einfo "    http://www.gentoo.org/doc/en/power-management-guide.xml"
	echo
	elog "As of version 1.0.6, acpid uses system log facility instead of custom log"
	elog "file. This means acpid messages will be usually located in "
	elog "/var/log/messages (and not in /var/log/acpid) for common setups."
	echo
}
