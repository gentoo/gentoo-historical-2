# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ntfs3g/ntfs3g-0.20070207_rc1.ebuild,v 1.1 2007/02/07 16:49:57 chutzpah Exp $

MY_PN="${PN/3g/-3g}"
MY_PV="${PV//_rc/-RC}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.ntfs-3g.org"
SRC_URI="http://www.ntfs-3g.org/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="suid"

RDEPEND=">=sys-fs/fuse-2.6.3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# default makefile calls ldconfig
	sed -ie '/\$(LDCONFIG)$/ d' src/Makefile.*
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog CREDITS NEWS README

	use suid && fperms u+s /usr/bin/${MY_PN}
}

pkg_postinst() {
	if use suid; then
		ewarn
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
		ewarn
	fi
}
