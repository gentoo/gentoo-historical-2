# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tinyca/tinyca-0.3.4.ebuild,v 1.6 2003/02/13 09:09:47 vapier Exp $

S="${WORKDIR}/TinyCA"
DESCRIPTION="Simple Perl/Tk GUI to manage a small certification authority"
SRC_URI="http://tinyca.sm-zone.net/${P}.tar.bz2"
HOMEPAGE="http://tinyca.sm-zone.net"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86"

DEPEND=">=dev-libs/openssl-0.9.6b
	>=dev-perl/MIME-Base64-2.12
	>=dev-perl/perl-tk-800.024
	>=dev-perl/OpenCA-OpenSSL-0.8.43
	>=dev-perl/OpenCA-X509-0.9.8
	>=dev-perl/OpenCA-CRL-0.7.61
	>=dev-perl/OpenCA-REQ-0.7.35"


src_unpack() {
	unpack ${A}
	cd ${S}
	# this app was written to be run from cwd and not meant to be installed
	# this little hack fixes that... pretty silly if you ask me
	cat tinyca | sed -e "s:\./lib:/usr/share/tinyca/lib:" \
	-e "s:\./template:/usr/share/tinyca/template:" > tinyca
}


src_install () {
	dodir /usr/bin
	exeinto /usr/share/tinyca/
	doexe tinyca
	dosym /usr/share/tinyca/tinyca /usr/bin/tinyca
	insinto /usr/share/tinyca/lib
	doins lib/*
	insinto /usr/share/tinyca/templates
	doins templates/*
}
