# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/xfsprogs/xfsprogs-1.3.13.ebuild,v 1.1 2003/09/15 17:46:25 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="xfs filesystem utilities"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/latest/cmd_tars/${P}.src.tar.gz"
HOMEPAGE="http://oss.sgi.com/projects/xfs"

SLOT="0"
LICENSE="LGPL-2.1 GPL-2"
KEYWORDS="x86 amd64"

DEPEND="virtual/glibc
	sys-devel/autoconf
	sys-devel/make
	sys-fs/e2fsprogs"

RDEPEND="virtual/glibc"

src_compile() {
	cd ${S}
	export OPTIMIZER="${CFLAGS}"
	export DEBUG=-DNDEBUG
	autoconf || die
	./configure --prefix=/usr || die
	# 1) add a ${DESTDIR} prefix to all install paths so we can relocate during the "install" phase
	# 2) we also set the /usr/share/doc/ directory to the correct value.
	# 3) we remove a hard-coded "-O1"
	# 4) we fix some Makefile-created library symlinks that contains absolute paths
	cp include/builddefs include/builddefs.orig
	sed -e 's:^PKG_\(.*\)_DIR = \(.*\)$:PKG_\1_DIR = ${DESTDIR}\2:' \
	    -e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:" \
	    -e 's:-O1::' \
	    -e '/-S $(PKG/d' \
	    include/builddefs.orig > include/builddefs || die
	emake || die
}

src_install() {
	make DESTDIR=${D} DK_INC_DIR=${D}/usr/include/disk install install-dev || die
}
