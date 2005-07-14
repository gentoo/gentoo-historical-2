# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/parrot/parrot-0.2.1.ebuild,v 1.3 2005/07/14 21:07:36 agriffis Exp $

inherit base eutils

DESCRIPTION="The virtual machine that perl6 relies on."
HOMEPAGE="http://www.parrotcode.org/"
SRC_URI="mirror://cpan/authors/id/L/LT/LTOETSCH/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="gdbm gmp python"

#this ebuild has been tested with the given perl
#if we trust the README then 5.6 should also be ok.
DEPEND=">=dev-lang/perl-5.8.5-r2
		>=dev-libs/icu-2.6
		gdbm? ( >=sys-libs/gdbm-1.8.3-r1 )
		gmp? ( >=dev-libs/gmp-4.1.4 )
		python? ( >=dev-lang/python-2.3.4-r1  )
		"
#		>=dev-java/antlr-2.7.5 #hard-masked right now

src_unpack ()   {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/mod_parrot.patch
}

src_compile()	{
	#This configure defines the DESTDIR for make.
	perl Configure.pl --prefix=${D}|| die "Perl ./Configure.pl failed"
	emake -j1 || die "emake failed"
}

src_install()	{

	#The prefix was set by Configure.pl - see src_compile().
	make install BUILDPREFIX=${D} PREFIX=/usr/lib/${P} || die
	dodir /usr/bin
	dosym /usr/lib/${P}/bin/parrot /usr/bin

	#copy some files especially for mod_parrot-0.2
	#maybe this should depend on a USE-Flag i.e. apache

	#install libparrot.a into /usr/lib/
	dolib.a blib/lib/*.a
	dosym /usr/lib/${P}/bin/parrot /usr/lib/${P}/parrot

	insinto /usr/lib/${P}
	doins config_lib.pasm

	#copy Header files
	dodir /usr/lib/${P}/include
	dodir /usr/lib/${P}/include/parrot
	insinto /usr/lib/${P}/include/parrot/
	doins ${S}/include/parrot/*.h

	dodir /usr/share/doc/${P}
	dodoc README RESPONSIBLE_PARTIES ABI_CHANGES ChangeLog CREDITS
}
