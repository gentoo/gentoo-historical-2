# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/disspam/disspam-0.14.ebuild,v 1.4 2005/06/05 11:54:33 hansmi Exp $

DESCRIPTION="A Perl script that removes spam from POP3 mailboxes based on RBLs."
HOMEPAGE="http://www.topfx.com/"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~hppa ~mips ppc sparc x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.1
	>=dev-perl/libnet-1.11
	>=sys-apps/sed-4
	>=dev-perl/Net-DNS-0.12"

src_unpack() {
	unpack ${A}
	cd ${S}

	#This doesnt look neat but makes it work
	sed -i \
		-e 's/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/' disspam.pl || \
			die "sed disspam.pl failed"
}

src_install() {
	dobin disspam.pl
	dodoc changes.txt configuration.txt readme.txt sample.conf
}
