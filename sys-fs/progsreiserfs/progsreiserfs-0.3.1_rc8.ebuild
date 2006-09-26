# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/progsreiserfs/progsreiserfs-0.3.1_rc8.ebuild,v 1.6 2006/09/26 03:35:02 tsunam Exp $

inherit libtool flag-o-matic

MY_P="${PN}-${PV/_/-}"
DESCRIPTION="Library for accessing and manipulating reiserfs partitions"
HOMEPAGE="http://reiserfs.linux.kiev.ua/"
SRC_URI="http://reiserfs.linux.kiev.ua/snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="nls debug"

RDEPEND=""
DEPEND="sys-fs/e2fsprogs
		nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

progsreiserfs_warning() {
	ewarn "progsreiserfs has been proven dangerous in the past, generating bad"
	ewarn "partitions and destroying data on resize/cpfs operations."
	ewarn "Because of this, we do NOT provide their binaries, but only their"
	ewarn "libraries instead, as these are needed for other applications."
}

src_compile() {
	elibtoolize
	filter-lfs-flags
	econf \
		--disable-Werror \
		$(use_enable nls) \
		$(use_enable debug) \
		|| die "Configure failed"
	emake || die "Make failed"
	progsreiserfs_warning
}

src_install() {
	make install DESTDIR="${D}" || die "Install failed"
	# Make sure users only use the official namesys binaries
	rm -r "${D}"/usr/{sbin,share/man} || die "cant punt the cruft"

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	docinto demos
	dodoc demos/*.c
	progsreiserfs_warning
}

pkg_postinst() {
	progsreiserfs_warning
}
pkg_preinst() {
	progsreiserfs_warning
}
