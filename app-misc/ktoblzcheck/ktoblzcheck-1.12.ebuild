# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ktoblzcheck/ktoblzcheck-1.12.ebuild,v 1.1 2006/11/24 20:35:09 hanno Exp $

DESCRIPTION="Library to check account numbers and bank codes of German banks"
HOMEPAGE="http://ktoblzcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktoblzcheck/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="python"

DEPEND="sys-apps/gawk
	sys-apps/grep
	sys-devel/libtool
	python? ( dev-python/ctypes )"

src_compile() {
	econf `use_enable python` || die
	emake || die
}

src_install() {
	einstall BANKDATA_PATH="${D}/usr/share/ktoblzcheck" || die
}
