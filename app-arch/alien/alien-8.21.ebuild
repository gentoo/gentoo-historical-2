# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/alien/alien-8.21.ebuild,v 1.3 2003/03/11 21:11:44 seemant Exp $

S=${WORKDIR}/${PN}
IUSE=""
DESCRIPTION="Converts between the rpm, dpkg, stampede slp, and slackware tgz file formats"
SRC_URI="http://kitenet.net/programs/code/alien/${PN}_${PV}.tar.gz"
HOMEPAGE="http://kitenet.net/programs/alien/"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"

SLOT="0"

DEPEND=">=dev-lang/perl-5.6.0
	>=app-arch/rpm-4.0.4-r4
	>=sys-apps/bzip2-1.0.2-r2
	>=app-arch/dpkg-1.10.9"

RDEPEND="${DEPEND}"

src_compile() {
	perl Makefile.PL || die "perl faild"
	emake || die "emake failed."
}

src_install() {
	dodir /usr/lib/perl5/site_perl/5.6.1/Alien/Package
	make install PREFIX=${D}/usr \
	    INSTALLMAN1DIR=${D}/usr/share/man/man1 \
	    INSTALLMAN3DIR=${D}/usr/share/man/man3 \
	    VARPREFIX=${D}
	dodoc COPYING INSTALL README TODO
}




