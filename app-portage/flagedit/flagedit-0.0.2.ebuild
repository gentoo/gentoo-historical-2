# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/flagedit/flagedit-0.0.2.ebuild,v 1.2 2005/10/15 11:30:57 dams Exp $

DESCRIPTION="CLI use flags and keyword editor, for system wide or /etc/portage files"
HOMEPAGE="http://damz.net/flagedit/"
SRC_URI="http://damz.net/flagedit/download/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

RDEPEND="dev-lang/perl
>=dev-util/libconf-0.40.00"

src_install() {
	make install PREFIX="${D}"/usr || die "make install failed"
}
