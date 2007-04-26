# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tkdiff/tkdiff-4.1.3.ebuild,v 1.3 2007/04/26 06:46:35 opfer Exp $

MY_P="${P}-unix"
DESCRIPTION="tkdiff is a graphical front end to the diff program"
HOMEPAGE="http://tkdiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/tkdiff/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=dev-lang/tk-8.4"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin tkdiff
	dodoc Changelog
}
