# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/testdisk/testdisk-6.5.ebuild,v 1.6 2011/02/25 18:13:56 signals Exp $

DESCRIPTION="Checks and undeletes partitions + PhotoRec, signature based recovery tool"
HOMEPAGE="http://www.cgsecurity.org/wiki/TestDisk"
SRC_URI="http://www.cgsecurity.org/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="static reiserfs ntfs jpeg"
# WARNING: reiserfs support does NOT work with reiserfsprogs
# you MUST use progsreiserfs-0.3.1_rc8 (the last version ever released).
DEPEND=">=sys-libs/ncurses-5.2
		jpeg? ( virtual/jpeg )
	  	ntfs? ( >=sys-fs/ntfsprogs-1.9.4 )
	  	reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8 )
	  	>=sys-fs/e2fsprogs-1.35"
RDEPEND="!static? ( ${DEPEND} )"

src_compile() {
	local myconf
	# --with-foo are broken, any use of --with/--without disable the
	# functionality.
	# The following variation must be used.
	use reiserfs || myconf="${myconf} --without-reiserfs"
	use ntfs || myconf="${myconf} --without-ntfs"
	use jpeg || myconf="${myconf} --without-jpeg"

	econf ${myconf} || die

	# perform safety checks for NTFS and REISERFS
	if useq ntfs && egrep -q 'undef HAVE_LIBNTFS\>' "${S}"/config.h ; then
		die "Failed to find NTFS library."
	fi
	if useq reiserfs && egrep -q 'undef HAVE_LIBREISERFS\>' "${S}"/config.h ; then
		die "Failed to find reiserfs library."
	fi
	if useq jpeg && egrep -q 'undef HAVE_LIBJPEG\>' "${S}"/config.h ; then
		die "Failed to find jpeg library."
	fi

	# this is static method is the same used by upstream for their 'static' make
	# target, but better, as it doesn't break.
	use static && append-ldflags -static

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	[ "$PF" != "$P" ] && mv "${D}"/usr/share/doc/${P} "${D}"/usr/share/doc/${PF}
}
