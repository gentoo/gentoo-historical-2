# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/stow/stow-1.3.3.ebuild,v 1.27 2010/01/01 19:23:11 fauli Exp $

DESCRIPTION="manage installation of software in /usr/local"
HOMEPAGE="http://www.gnu.org/software/stow/"
SRC_URI="mirror://gnu/stow/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="dev-lang/perl"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
