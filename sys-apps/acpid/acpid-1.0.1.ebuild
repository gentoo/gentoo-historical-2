# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acpid/acpid-1.0.1.ebuild,v 1.2 2002/06/13 18:43:55 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Daemon for Advanced Configuration and Power Interface."
SRC_URI="ftp://download.sourceforge.net/pub/sourceforge/acpid/${P}.tar.gz"
HOMEPAGE="http://acpid.sourceforge.net/"

# We need the patched kernel with latest ACPI code, or else it will
# be broken.  Hopefully it will be merge into release kernel soon.
DEPEND="virtual/glibc
	virtual/linux-sources"


src_compile() {

	# DO NOT compile with optimizations !
	make INSTPREFIX=${D} ||die
}

src_install () {

	make INSTPREFIX=${D} install || die
	
	dodir /etc/acpi/events
	exeinto /etc/acpi
	doexe debian/default.sh
	insinto /etc/acpi/events
	doins debian/default
	
	dodoc README Changelog

	exeinto /etc/init.d
	newexe ${FILESDIR}/acpid.rc6 acpid
}
