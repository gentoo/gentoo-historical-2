# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rzip/rzip-2.0.ebuild,v 1.7 2004/06/24 21:35:54 agriffis Exp $

DESCRIPTION="compression program for large files"
HOMEPAGE="http://rzip.samba.org/"
SRC_URI="http://rzip.samba.org/ftp/rzip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="virtual/glibc
	sys-apps/coreutils
	app-arch/bzip2"

src_install() {
	einstall || die
}
