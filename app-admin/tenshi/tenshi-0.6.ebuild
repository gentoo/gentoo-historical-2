# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tenshi/tenshi-0.6.ebuild,v 1.1 2006/09/29 14:14:40 lcars Exp $

inherit eutils

DESCRIPTION="Log parsing and notification program"
HOMEPAGE="http://dev.inversepath.com/trac/tenshi"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.inversepath.com/tenshi/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	sys-apps/coreutils"

pkg_setup() {
	enewgroup tenshi
	enewuser tenshi -1 -1 /var/lib/tenshi tenshi
}

src_install() {
	emake DESTDIR=${D} install
	fowners tenshi:root /etc/tenshi/tenshi.conf
	fowners tenshi:root /var/lib/tenshi
	doman tenshi.8
	exeinto /etc/init.d
	newexe tenshi.gentoo-init tenshi
	keepdir /var/lib/tenshi
}
