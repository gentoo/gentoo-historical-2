# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/f-prot/f-prot-4.5.2.ebuild,v 1.3 2005/01/11 11:11:36 eradicator Exp $

IUSE="emul-linux-x86"

MY_P="fp-linux-ws-${PV}"
S=${WORKDIR}/${PN}

DESCRIPTION="Frisk Software's f-prot virus scanner"
HOMEPAGE="http://www.f-prot.com/"
SRC_URI="ftp://ftp.f-prot.com/pub/linux/${MY_P}.tar.gz"
DEPEND=""
# unzip and perl are needed for the check-updates.pl script
RDEPEND=">=app-arch/unzip-5.42-r1
	dev-lang/perl
	dev-perl/libwww-perl
	emul-linux-x86? ( >=app-emulation/emul-linux-x86-baselibs-1.0 )"
PROVIDE="virtual/antivirus"

SLOT="0"
LICENSE="F-PROT"
KEYWORDS="~x86 -ppc -sparc ~amd64"

src_install ()
{
	cd ${S}

	dobin f-prot.sh
	dosym /usr/bin/f-prot.sh /usr/bin/f-prot

	dodir /opt/f-prot /var/tmp/f-prot
	insinto /opt/f-prot
	insopts -m 755
	doins f-prot tools/check-updates.pl
	insopts -m 644
	doins *.DEF ENGLISH.TX0

	doman man_pages/*
	dodoc LICENSE* CHANGES README
	dohtml doc_ws/*

	dosed "s:/usr/local/f-prot:/opt/f-prot:g" /usr/bin/f-prot.sh /opt/f-prot/check-updates.pl
}
