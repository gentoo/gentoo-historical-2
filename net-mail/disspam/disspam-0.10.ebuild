# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/disspam/disspam-0.10.ebuild,v 1.9 2003/09/05 09:00:23 msterret Exp $

S=${WORKDIR}/disspam
DESCRIPTION="A Perl script that removes spam from POP3 mailboxes based on RBLs."
HOMEPAGE="http://www.topfx.com/"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 sparc "

DEPEND=">=dev-lang/perl-5.6.1
	>=dev-perl/libnet-1.11
	>=dev-perl/Net-DNS-0.12"

src_install() {
	dobin disspam.pl
	dodoc changes.txt configuration.txt readme.txt sample.conf
}
