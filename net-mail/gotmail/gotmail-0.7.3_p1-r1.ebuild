# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gotmail/gotmail-0.7.3_p1-r1.ebuild,v 1.1 2002/10/16 16:42:25 g2boojum Exp $

PV0=0.7.3
PDP=1
S=${WORKDIR}/${PN}-${PV0}
DESCRIPTION="Utility to download mail from a HotMail account"
SRC_URI="http://ftp.debian.org/debian/pool/main/g/${PN}/${PN}_${PV0}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/g/${PN}/${PN}_${PV0}-${PDP}.diff.gz"
HOMEPAGE="http://ssl.usu.edu/paul/gotmail/"

RDEPEND="virtual/glibc net-ftp/curl dev-perl/URI dev-perl/libnet"
DEPEND=${RDEPEND}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_unpack() {
	unpack ${PN}_${PV0}.orig.tar.gz
	zcat ${DISTDIR}/${PN}_${PV0}-${PDP}.diff.gz | patch -d ${S} -p1 || die
	# one-line fix so that gotmail works again (fix stolen from Debian's bugtracker)
	mv ${S}/gotmail ${S}/gotmail.orig || die
	sed -e 's/\\r//g' ${S}/gotmail.orig > ${S}/gotmail || die
}

src_compile() { :; }

src_install () {
	dobin gotmail
	dodoc COPYING ChangeLog README sample.gotmailrc
	doman gotmail.1
}
