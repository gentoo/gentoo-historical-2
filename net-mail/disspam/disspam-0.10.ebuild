# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/disspam/disspam-0.10.ebuild,v 1.3 2002/07/25 05:37:29 seemant Exp $

S=${WORKDIR}/disspam
DESCRIPTION="A Perl script that removes spam from POP3 mailboxes based on RBLs."
HOMEPAGE="http://www.topfx.com/"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86"

DEPEND=">=sys-devel/perl-5.6.1
	>=dev-perl/libnet-1.11
	>=dev-perl/Net-DNS-0.12"
	
src_install() {
	dobin disspam.pl
	dodoc changes.txt configuration.txt readme.txt sample.conf
}

pkg_postinst() {
	einfo "**************************************************************"
	einfo "* NOTE: DisSpam has been installed, check documentation	    *"
	einfo "* directory for sample configuration file sample.conf.  Also *"
	einfo "* instructions for setting up cron are in readme.txt.	    *"
	einfo "**************************************************************"
}
