# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/xfsprogs/xfsprogs-2.6.25.ebuild,v 1.10 2005/03/20 00:06:43 kloeri Exp $

inherit flag-o-matic eutils

DESCRIPTION="xfs filesystem utilities"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ~sparc x86"
IUSE="nls uclibc"

RDEPEND="virtual/libc
	sys-fs/e2fsprogs"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	# temp work around till a _syscall6() exists. bug #73855
	use uclibc && epatch ${FILESDIR}/2.6.25-uclibc-fadvise.patch

	sed -i \
		-e '/^GCFLAGS/s:-O1::' \
		-e "/^PKG_DOC_DIR/s:=.*:= /usr/share/doc/${PF}:" \
		-e '/^PKG_[[:upper:]]*_DIR/s:= := $(DESTDIR):' \
		include/builddefs.in \
		|| die "sed include/builddefs.in failed"
}

src_compile() {
	replace-flags -O[2-9] -O1
	export OPTIMIZER="${CFLAGS}"
	export DEBUG=-DNDEBUG

	# Some archs need the PLATFORM var unset 
	if hasq ${ARCH} mips ppc sparc; then
		unset PLATFORM
	fi

	econf \
		--bindir=/bin \
		--sbindir=/sbin \
		--libdir=/lib \
		--libexecdir=/lib \
		$(use_enable nls gettext) \
		|| die "config failed"
	emake || die
}

src_install() {
	make \
		DESTDIR=${D} \
		DK_INC_DIR=${D}/usr/include/disk \
		install install-dev \
		|| die "make install failed"
	dosym /lib/libhandle.so.1 /lib/libhandle.so

	dodir /usr/lib
	sed \
		-e 's:installed=no:installed=yes:g' \
		${S}/libhandle/.libs/libhandle.la \
		> ${D}/usr/lib/libhandle.la \
		|| die "sed failed"
	mv ${D}/lib/*.a ${D}/usr/lib/ || die "mv failed"
	prepalldocs
}
