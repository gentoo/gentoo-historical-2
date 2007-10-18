# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsepol/libsepol-1.16.6.ebuild,v 1.1 2007/10/18 19:26:16 pebenito Exp $

IUSE=""

inherit multilib eutils

#BUGFIX_PATCH="${FILESDIR}/libsepol-1.16.2.diff"

DESCRIPTION="SELinux binary policy representation library"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86"

DEPEND="virtual/libc"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	[ ! -z "$BUGFIX_PATCH" ] && epatch "${BUGFIX_PATCH}"

	# fix up paths for multilib
	sed -i -e "/^LIBDIR/s/lib/$(get_libdir)/" src/Makefile \
		|| die "Fix for multilib LIBDIR failed."
	sed -i -e "/^SHLIBDIR/s/lib/$(get_libdir)/" src/Makefile \
		|| die "Fix for multilib SHLIBDIR failed."
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
}
