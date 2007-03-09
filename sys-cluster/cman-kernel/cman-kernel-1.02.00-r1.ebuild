# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/cman-kernel/cman-kernel-1.02.00-r1.ebuild,v 1.12 2007/03/09 15:12:26 xmerlin Exp $

inherit eutils linux-mod linux-info

CLUSTER_RELEASE="1.02.00"
MY_P="cluster-${CLUSTER_RELEASE}"
CVS_RELEASE="20060714"

DESCRIPTION="CMAN cluster kernel module"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz
	mirror://gentoo/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz
	http://dev.gentoo.org/~xmerlin/gfs/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

IUSE=""
DEPEND="|| (
		>=sys-kernel/vanilla-sources-2.6.16
		>=sys-kernel/gentoo-sources-2.6.16
	)"
RDEPEND=""

S="${WORKDIR}/${MY_P}/${PN}"

pkg_setup() {
	linux-mod_pkg_setup
	case ${KV_FULL} in
		2.2.*|2.4.*) die "${P} supports only 2.6 kernels";;
	esac
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PN}-${PV}-${CVS_RELEASE}-cvs.patch || die

	if kernel_is 2 6; then
		if [ "$KV_PATCH" -ge "18" ] ; then
			sed -i \
				-e 's|version.h|utsrelease.h|g' \
				configure \
				|| die "sed failed"

			sed -i \
				-e 's|system_utsname.nodename|init_utsname()->nodename|g' \
				src/cnxman.c \
				|| die "sed failed"
		fi
	fi
}


src_compile() {
	set_arch_to_kernel

	./configure --kernel_src=${KERNEL_DIR} --verbose || die "configure error"
	emake || die "compile error"
}

src_install() {
	emake DESTDIR=${D} install || die "install error"
	rm -f ${D}/usr/include/cluster/*
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo ""
	einfo "Please remember to re-emerge ${PN} when you upgrade your kernel!"
	einfo ""
}
