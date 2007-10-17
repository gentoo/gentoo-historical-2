# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pvfs2/pvfs2-1.5.1.ebuild,v 1.3 2007/10/17 02:40:58 nerdboy Exp $

inherit linux-mod

DESCRIPTION="Parallel Virtual File System version 2"
HOMEPAGE="http://www.pvfs.org/pvfs2/"
SRC_URI="ftp://ftp.parl.clemson.edu/pub/pvfs2/${P}.tar.gz"
IUSE="gtk static doc"
RDEPEND="gtk? ( >=x11-libs/gtk+-2 )
		 sys-libs/db"
DEPEND="${RDEPEND}
		virtual/linux-sources"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is 2 4; then
		BUILD_TARGETS="kmod24 all"
		ECONF_PARAMS="--with-kernel24=${KV_DIR}"
		MODULE_NAMES="pvfs2(fs::src/kernel/linux-2.4)"
	else
		BUILD_TARGETS="kmod all"
		ECONF_PARAMS="--with-kernel=${KV_DIR}"
		MODULE_NAMES="pvfs2(fs::src/kernel/linux-2.6)"
	fi
	ECONF_PARAMS="${ECONF_PARAMS} --enable-mmap-racache $(use_enable !static shared) $(use_enable static)"
	ECONF_PARAMS="${ECONF_PARAMS} $(use_enable gtk karma)"
}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-destdir.patch
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS CREDITS ChangeLog INSTALL README
	docinto examples
	dodoc examples/{fs.conf,pvfs2-server.rc,server.conf-localhost}
	# this is LARGE (~5mb)
	if use doc; then
		docdir="/usr/share/doc/${PF}/"
		cp -pPR "${S}/doc" "${D}${docdir}"
		rm -rf "${D}${docdir}/man"
	fi
}
