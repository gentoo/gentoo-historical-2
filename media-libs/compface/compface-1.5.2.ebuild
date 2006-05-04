# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/compface/compface-1.5.2.ebuild,v 1.2 2006/05/04 14:02:00 hattya Exp $

IUSE=""

inherit eutils

DESCRIPTION="Utilities and library to convert to/from X-Face format"
HOMEPAGE="http://www.xemacs.org/Download/optLibs.html"
SRC_URI="http://ftp.xemacs.org/pub/xemacs/aux/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~hppa ia64 ~ppc ~ppc-macos ~ppc64 ~sparc x86"
SLOT="0"

DEPEND=""

src_unpack() {

	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-destdir.diff
	autoconf

}

src_install() {

	make DESTDIR="${D}" install || die

	newbin xbm2xface{.pl,}
	dodoc README ChangeLog

}
