# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/desktop-file-utils/desktop-file-utils-0.9.ebuild,v 1.8 2004/12/11 10:22:05 kloeri Exp $

inherit eutils

DESCRIPTION="Command line utilities to work with desktop menu entries"
HOMEPAGE="http://www.freedesktop.org/software/desktop-file-utils/"
SRC_URI="http://www.freedesktop.org/software/desktop-file-utils/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc sparc ~ppc64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0.0
	>=dev-libs/popt-1.6.3"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {

	unpack ${A}
	# patch that disables auto pre-compiling of emacs mode file.
	cd ${S}; epatch ${FILESDIR}/${PN}-0.8-noemacs.patch

}

src_install() {

	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README

}
