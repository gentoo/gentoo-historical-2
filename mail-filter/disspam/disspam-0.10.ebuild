# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/disspam/disspam-0.10.ebuild,v 1.2 2004/06/24 22:20:45 agriffis Exp $

S=${WORKDIR}/disspam
DESCRIPTION="A Perl script that removes spam from POP3 mailboxes based on RBLs."
HOMEPAGE="http://www.topfx.com/"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 sparc"

DEPEND=">=dev-lang/perl-5.6.1
	>=dev-perl/libnet-1.11
	>=dev-perl/Net-DNS-0.12"

src_install() {
	dobin disspam.pl
	dodoc changes.txt configuration.txt readme.txt sample.conf
}
