# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/libnasl/libnasl-2.2.0.ebuild,v 1.7 2005/03/31 10:06:31 kloeri Exp $

inherit eutils

DESCRIPTION="A remote security scanner for Linux (libnasl)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~amd64 ~ppc64"
IUSE=""

DEPEND="=net-analyzer/nessus-libraries-${PV}"

S=${WORKDIR}/${PN}

src_compile() {
	econf || die "configuration failed"
	# emake fails for >= -j2. bug #16471.
	make || die "make failed"
}

src_install() {
	make \
		DESTDIR=${D} \
		install || die "Install failed libnasl"
	dodoc COPYING
}
