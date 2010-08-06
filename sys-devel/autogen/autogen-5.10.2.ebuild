# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autogen/autogen-5.10.2.ebuild,v 1.2 2010/08/06 18:33:45 darkside Exp $

EAPI="3"
inherit eutils

DESCRIPTION="Program and text file generation"
HOMEPAGE="http://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${PN}/rel${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

# autogen doesn't build with lower versions of guile on ia64
DEPEND=">=dev-scheme/guile-1.6.6
	dev-libs/libxml2"

pkg_setup() {
	has_version '>=dev-scheme/guile-1.8' || return 0
	if ! built_with_use --missing false dev-scheme/guile deprecated threads ; then
		eerror "You need to build dev-scheme/guile with USE='deprecated threads'"
		die "re-emerge dev-scheme/guile with USE='deprecated threads'"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO
	rm -f "${ED}"/usr/share/autogen/libopts-*.tar.gz
}
