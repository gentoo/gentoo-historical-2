# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dazuko/dazuko-2.3.2-r3.ebuild,v 1.2 2007/01/10 17:52:46 alonbl Exp $
inherit linux-mod toolchain-funcs flag-o-matic

DESCRIPTION="Linux kernel module and interface providing file access control"
MY_P="${P/_/-}" # for -preN versions
SRC_URI="http://www.dazuko.org/files/${MY_P}.tar.gz
	mirror://gentoo/${P}-linux-2.6.19.patch.bz2"
HOMEPAGE="http://www.dazuko.org"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND="kernel_linux? ( >=virtual/linux-sources-2.2 )"
RDEPEND=${DEPEND}
S="${WORKDIR}/${MY_P}"

# kernel settings
CONFIG_CHECK="SECURITY_CAPABILITIES"
MODULE_NAMES="dazuko(misc:)"
BUILD_TARGETS="dummy_rule"

pkg_setup() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-2.3.1-suspend2.patch"

	if [ "${KERNEL}" == "linux" ] && kernel_is 2 6 19; then
		epatch "${WORKDIR}/${P}-linux-2.6.19.patch"
	fi
}

src_compile() {
	if [ "${KERNEL}" = "FreeBSD" ]; then
		KERNEL_DIR=/usr/src/sys
		KBUILD_OUTPUT=/boot/modules
		MAKE=make
	fi
	./configure \
		--without-dep \
		--disable-local-dpath \
		--disable-chroot-support \
		--kernelsrcdir="${KERNEL_DIR}" \
		--kernelobjdir="${KBUILD_OUTPUT}" \
		|| die "configure failed"

	if [ "${KERNEL}" = "linux" ]; then
		convert_to_m Makefile
		linux-mod_src_compile
	else
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" LDFLAGS="$(raw-ldflags)" || die
	fi

	emake -C library CC="$(tc-getCC)" || die
}

src_install() {
	if [ "${KERNEL}" = "linux" ]; then
		linux-mod_src_install
	else
		insinto /boot/modules
		doins "${S}"/dazuko.kld
		exeinto /boot/modules
		doexe "${S}"/dazuko.ko
	fi

	dolib.a library/libdazuko.a
	insinto /usr/include
	doins dazukoio.h

	dodoc COPYING
	dodoc README
	dodoc README.linux26
	dodoc README.trusted
}

src_test() {
	if [ "${EUID}" != 0 ]; then
		ewarn "Cannot test while not root"
	else
		emake test || die "Test failed"
	fi
}

pkg_postinst() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_postinst

	einfo "Please note that chroot support is disabled due to incompatability "
	einfo "with SMP kernels"
}

pkg_postrm() {
	[ "${KERNEL}" = "linux" ] && linux-mod_pkg_postrm
}

