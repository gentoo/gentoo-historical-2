# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.2.18.ebuild,v 1.2 2005/02/20 17:40:02 azarah Exp $

inherit eutils flag-o-matic gnuconfig toolchain-funcs

SELINUX_PATCH="findutils-4.2.18-selinux.diff"

# Note this doesn't point to gnu.org because alpha.gnu.org has quit
# supplying the development versions.  If it comes back in the future
# then we might want to redirect the link.  See bug 18729
DESCRIPTION="GNU utilities to find files"
HOMEPAGE="http://www.gnu.org/software/findutils/findutils.html"
SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
	mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls build afs selinux static"

DEPEND="virtual/libc
	>=sys-apps/sed-4
	nls? ( sys-devel/gettext )
	afs? ( net-fs/openafs )
	selinux? ( sys-libs/libselinux )"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Detect new systems properly
	gnuconfig_update

	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in

	# Fix variable definition to be gcc-2.95.3 compatible
	epatch ${FILESDIR}/${P}-gcc295.patch

	# Patches for selinux
	use selinux && epatch ${FILESDIR}/${SELINUX_PATCH}
}

src_compile() {
	if use afs && use x86; then
		append-flags -I/usr/afsws/include
		append-ldflags -lpam
		export LIBS="/usr/afsws/lib/pam_afs.so.1 -lpam"
	fi
	export CPPFLAGS="${CXXFLAGS}"
	use static && append-ldflags -static

	econf $(use_enable nls) || die
	emake libexecdir=/usr/lib/find AR="$(tc-getAR)" || die
}

src_install() {
	einstall libexecdir=${D}/usr/lib/find || die
	prepallman

	rm -rf ${D}/usr/var
	use build \
		&& rm -rf ${D}/usr/share \
		|| dodoc NEWS README TODO ChangeLog
}

pkg_postinst() {
	ewarn "Please note that the locate and updatedb binaries"
	ewarn "are not longer provided by findutils."
	ewarn "Please emerge slocate"
}
