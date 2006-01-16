# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse/fuse-2.5.0.ebuild,v 1.1 2006/01/16 15:10:48 genstef Exp $

inherit linux-mod eutils

MY_P=${P/_/-}
DESCRIPTION="An interface for filesystems implemented in userspace."
HOMEPAGE="http://fuse.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
S=${WORKDIR}/${MY_P}

MODULE_NAMES="fuse(fs:${S}/kernel)"
BUILD_PARAMS="majver=${KV_MAJOR}.${KV_MINOR}
			  fusemoduledir=${ROOT}/lib/modules/${KV_FULL}/fs"
BUILD_TARGETS="all"
ECONF_PARAMS="--with-kernel=${KV_OUT_DIR} --enable-kernel-module"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/fuse-fix-lazy-binding.patch
}

src_compile() {
	einfo "Preparing fuse userland"
	econf --disable-kernel-module --disable-example || \
		die "econf failed for fuse userland"
	emake || die "emake failed"

	sed -i 's/.*depmod.*//g' ${S}/kernel/Makefile.in
	convert_to_m ${S}/kernel/Makefile.in
	linux-mod_src_compile
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog Filesystems README README-2.4 \
		README.NFS NEWS doc/how-fuse-works
	docinto example
	dodoc example/*

	linux-mod_src_install
}
