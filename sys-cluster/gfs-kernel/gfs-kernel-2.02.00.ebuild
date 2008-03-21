# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gfs-kernel/gfs-kernel-2.02.00.ebuild,v 1.2 2008/03/21 02:21:04 xmerlin Exp $

inherit eutils linux-mod linux-info versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2).$(get_version_component_range 3)"

DESCRIPTION="GFS kernel module"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="=virtual/linux-sources-2.6.24*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

pkg_setup() {
	linux-mod_pkg_setup
	case ${KV_FULL} in
		2.2.*|2.4.*) die "${P} supports only 2.6 kernels";;
	esac
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if kernel_is 2 6; then
		if [ "$KV_PATCH" -lt "24" ] ; then
			epatch "${FILESDIR}"/${P}-before-2.6.24.diff || die
		fi
		if [ "$KV_PATCH" -lt "23" ] ; then
			epatch "${FILESDIR}"/${P}-before-2.6.23.diff || die
		fi
	fi
}

src_compile() {
	set_arch_to_kernel

	(cd "${WORKDIR}"/${MY_P};
		./configure \
			--cc=$(tc-getCC) \
			--cflags="-Wall" \
			--kernel_src="${KERNEL_DIR}" \
			--disable_kernel_check \
			--release_major="$MAJ_PV" \
			--release_minor="$MIN_PV" \
	) || die "configure problem"

	(cd "${S}"/src/gfs;
		emake clean all \
	) || die "compile problem"
}

src_install() {
	(cd "${S}"/src/gfs;
		emake DESTDIR="${D}" module_dir="${D}"/lib/modules/${KV_FULL} install \
	) || die "install problem"

	dodoc "${FILESDIR}"/gfs-kernel-locking-symbol.patch || die
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo ""
	einfo "Please remember to re-emerge ${PN} when you upgrade your kernel!"
	einfo ""
	einfo "To use this kernel module you have to path your kernel with"
	einfo "/usr/share/doc/${P}/gfs-kernel-locking-symbol.patch (bug #210495)"
	einfo ""
}
