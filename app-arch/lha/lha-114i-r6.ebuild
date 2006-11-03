# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lha/lha-114i-r6.ebuild,v 1.4 2006/11/03 14:07:38 grobian Exp $

MY_P="${PN}-1.14i-ac20050924p1"
DESCRIPTION="Utility for creating and opening lzh archives"
HOMEPAGE="http://lha.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/lha/22231/${MY_P}.tar.gz"

LICENSE="lha"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ppc-macos ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" \
		mandir=/usr/share/man/ja \
		install || die

	dodoc 00readme.autoconf ChangeLog Hacking_of_LHa
}
