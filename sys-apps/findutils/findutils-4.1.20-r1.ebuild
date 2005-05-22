# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.1.20-r1.ebuild,v 1.28 2005/05/22 02:04:48 vapier Exp $

inherit eutils flag-o-matic gnuconfig toolchain-funcs

SELINUX_PATCH="findutils-4.1.20-selinux.diff"

# Note this doesn't point to gnu.org because alpha.gnu.org has quit
# supplying the development versions.  If it comes back in the future
# then we might want to redirect the link.  See bug 18729
DESCRIPTION="GNU utilities to find files"
HOMEPAGE="http://www.gnu.org/software/findutils/findutils.html"
SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
	mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
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

	#get a bigger environment as ebuild.sh is growing large
	epatch ${FILESDIR}/findutils-env-size.patch

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
