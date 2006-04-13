# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/linuxsms/linuxsms-0.77.ebuild,v 1.3 2006/04/13 19:35:17 mrness Exp $

DESCRIPTION="A console perl script for sending SMS to cell phones"
HOMEPAGE="http://linuxsms.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm ppc s390 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1"

src_install() {
	dobin linuxsms || die "could not install the script"
	doman linuxsms.1
	dodoc BUGS CHANGES README README.ES TODO
}
