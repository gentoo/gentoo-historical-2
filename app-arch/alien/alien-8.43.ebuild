# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/alien/alien-8.43.ebuild,v 1.3 2004/06/24 21:27:11 agriffis Exp $

DESCRIPTION="Converts between the rpm, dpkg, stampede slp, and slackware tgz file formats"
HOMEPAGE="http://kitenet.net/programs/alien/"
SRC_URI="http://kitenet.net/programs/alien/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.0
	>=app-arch/rpm-4.0.4-r4
	>=app-arch/bzip2-1.0.2-r2
	>=app-arch/dpkg-1.10.9"

S=${WORKDIR}/${PN}

src_compile() {
	perl Makefile.PL PREFIX="${D}/usr" || die "configuration failed"
	emake || die "emake failed."
}

src_install() {
	dodir /usr/lib/perl5/site_perl/`perl -e 'printf "%vd", $^V;'`/Alien/Package
	make install PREFIX=${D}/usr \
	    INSTALLMAN1DIR=${D}/usr/share/man/man1 \
	    INSTALLMAN3DIR=${D}/usr/share/man/man3 \
	    VARPREFIX=${D}
	dodoc INSTALL README TODO
}
