# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/f-prot/f-prot-4.3.0.ebuild,v 1.4 2004/09/24 14:43:05 ticho Exp $

IUSE=""

MY_P="fp-linux-ws-${PV}"
S=${WORKDIR}/${PN}

DESCRIPTION="Frisk Software's f-prot virus scanner"
HOMEPAGE="http://www.f-prot.com/"
SRC_URI="ftp://ftp.f-prot.com/pub/linux/${MY_P}.tar.gz"
DEPEND=""
# unzip and perl are needed for the check-updates.pl script
RDEPEND=">=app-arch/unzip-5.42-r1
	dev-lang/perl
	dev-perl/libwww-perl"
PROVIDE="virtual/antivirus"

SLOT="0"
LICENSE="F-PROT"
KEYWORDS="~x86 -sparc -ppc"

src_install ()
{
	cd ${S}

	dobin f-prot.sh

	dodir /opt/f-prot /var/tmp/f-prot
	insinto /opt/f-prot
	insopts -m 755
	doins f-prot tools/check-updates.pl
	insopts -m 644
	doins *.DEF ENGLISH.TX0

	doman man_pages/*
	dodoc LICENSE* CHANGES INSTALL* README
	dohtml doc_ws/*

	dosed "s:/usr/local/f-prot:/opt/f-prot:g" /usr/bin/f-prot.sh /opt/f-prot/check-updates.pl
}
