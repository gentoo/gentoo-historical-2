# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/makepasswd/makepasswd-1.10.ebuild,v 1.5 2002/08/16 02:21:27 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Random password generator"
SRC_URI="http://ftp.debian.org/debian/dists/stable/main/source/admin/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://packages.debian.org/stable/admin/makepasswd.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="${RDEPEND}"
RDEPEND="sys-devel/perl"

src_install () {
	into /usr
	dobin makepasswd
	doman makepasswd.1
	dodoc README CHANGES COPYING-2.0
}
