# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pvm/pvm-3.4.4-r1.ebuild,v 1.7 2004/04/27 21:46:06 agriffis Exp $

inherit eutils

MY_P="${P/-}"
DESCRIPTION="PVM: Parallel Virtual Machine"
HOMEPAGE="http://www.epm.ornl.gov/pvm/pvm_home.html"
SRC_URI="ftp://ftp.netlib.org/pvm3/${MY_P}.tgz "
IUSE=""
DEPEND=""
RDEPEND="virtual/glibc"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~alpha"
S="${WORKDIR}/${MY_P%%.*}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff || die
}

src_compile() {
	export PVM_ROOT="${S}"
	emake || die
}

src_install() {
	dodir /usr/share/man
	rm man/man1 -fr
	mv man/man3 ${D}/usr/share/man/
	prepallman

	dodoc Readme

	#installs the rest of pvm
	dodir /usr/local/pvm3
	cp -r * ${D}/usr/local/pvm3

	#environment variables:
	touch 98pvm
	echo PVM_ROOT=/usr/local/pvm3 >98pvm
	echo PVM_ARCH=LINUX >>98pvm
	insinto /etc/env.d
	doins 98pvm
}

pkg_postinst() {
	ewarn "Environment Variables have changed. Do not forget to reboot or perform"
	ewarn "source /etc/profile before using pvm !"
}
