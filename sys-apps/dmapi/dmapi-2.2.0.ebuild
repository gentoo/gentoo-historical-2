# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dmapi/dmapi-2.2.0.ebuild,v 1.3 2004/10/08 13:05:24 vapier Exp $

inherit eutils

DESCRIPTION="XFS data management API library"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc ~sparc x86"
IUSE="debug static"

DEPEND="sys-fs/xfsprogs"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e 's:^PKG_\(.*\)_DIR[[:space:]]*= \(.*\)$:PKG_\1_DIR = $(DESTDIR)\2:' \
		-e 's:-O1::' \
		-e 's:../$(INSTALL) -S \(.*\) $(PKG_.*_DIR)/\(.*$\)::' \
		include/builddefs.in || die
}

src_compile() {
	if use debug; then
		DEBUG=-DDEBUG
		OPTIMIZER="-g"
		CFLAGS=
		CXXFLAGS=
		export CFLAGS CXXFLAGS
	else
		DEBUG=-DNDEBUG
		OPTIMIZER="${CFLAGS}"
	fi
	export DEBUG OPTIMIZER

	# Some archs need the PLATFORM var unset
	if hasq ${ARCH} mips ppc sparc ppc64 s390; then
		unset PLATFORM
	fi

	autoconf || die

	local myconf
	LIBDIR="`get_libdir`"
	myconf="${myconf} --libdir=/${LIBDIR} --libexecdir=/usr/${LIBDIR}"
	myconf="${myconf} `use_enable !static shared`"
	econf ${myconf}	|| die
	emake || die
}

src_install() {
	make DESTDIR=${D} install install-dev || die
}
