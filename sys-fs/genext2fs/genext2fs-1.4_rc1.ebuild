# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/genext2fs/genext2fs-1.4_rc1.ebuild,v 1.1.1.1 2005/11/30 09:44:20 chriswhite Exp $

inherit eutils

DESCRIPTION="generate ext2 file systems"
HOMEPAGE="http://sourceforge.net/projects/genext2fs"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${P/_/}

src_install() {
	make install DESTDIR="${D}" || die
}
