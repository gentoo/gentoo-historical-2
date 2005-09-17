# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/l7-filter/l7-filter-1.5.ebuild,v 1.1 2005/09/17 09:17:35 dragonheart Exp $

inherit linux-info eutils

MY_P=netfilter-layer7-v${PV}
DESCRIPTION="Kernel modules for layer 7 iptables filtering"
HOMEPAGE="http://l7-filter.sourceforge.net"
SRC_URI="mirror://sourceforge/l7-filter/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
#break repoman
#SLOT="${KV}"
SLOT="0"
S=${WORKDIR}/${MY_P}
RDEPEND="net-misc/l7-protocols"


which_patch() {
	if kernel_is ge 2 6 13
	then
		PATCH=kernel-2.6.13-layer7-${PV}.patch
	elif kernel_is ge 2 6 11
	then
		PATCH=for_older_kernels/kernel-2.6.11-2.6.12-layer7-1.4.patch
	elif kernel_is ge 2 6 9
	then
		PATCH=for_older_kernels/kernel-2.6.9-2.6.10-layer7-1.2.patch
	elif kernel_is 2 6
	then
		# 2.6.0-2.6.8.1
		PATCH=for_older_kernels/kernel-2.6.0-2.6.8.1-layer7-0.9.2.patch
	elif kernel_is 2 4
	then
		PATCH=kernel-2.4-layer7-${PV}.patch
	else
		die "No L7-filter patch for Kernel version ${KV_FULL} - sorry not supported"
	fi
}

pkg_setup() {
	pkg_postinst
}

src_unpack() {

	which_patch

	if [ -f ${KV_DIR}/include/linux/netfilter_ipv4/ipt_layer7.h ]
	then
		ewarn "already installed ${PF} for kernel ${KV_FULL}"
		return 0;
	fi

	unpack ${MY_P}.tar.gz

	[ ! -f "${S}/${PATCH}" ] && \
		die "patch ${PATCH} not found. Please enter a bug at bugs.gentoo.org"


	cd ${S}

	mkdir  kernel
	mkdir  kernel/Documentation


	# create needed directories
	mkdir -p ${S}/kernel/net/ipv4/netfilter/regexp/
	mkdir -p ${S}/kernel/include/linux/netfilter_ipv4/

	cd ${KV_DIR}

	# start to copy needed files, if file not exists create an empty file
	FILES=$(patch -t --dry-run -p1 < ${S}/${PATCH} | grep "^patching file" | cut -f 3 -d ' ')
	for F in ${FILES};
	do
		if [ -f ${F} ];
		then
			cp -P ${F} ${S}/kernel/${F}
		else
			touch ${S}/kernel/${F}
		fi
	done

	#patch the copied kernel source
	cd ${S}/kernel
	EPATCH_OPTS="-F 3" epatch "${S}/${PATCH}"
}

src_compile() {
	einfo "no compiling - just patching source"
}

src_install() {
	insinto "${KV_DIR}"
	doins -r kernel/*
	dodoc CHANGELOG README
}


pkg_postinst() {
	ewarn "This may not work with all kernels. If it does not work please enter a bug at bugs.gentoo.org"
	ewarn "This only patches the current kernel source code. (${KV_DIR})"
	ewarn "Its up to you to recompile the kernel with the l7 options"
	ewarn
	ewarn 'You will also need to emerge iptables with the "extensions" USE flag'
}

pkg_prerm() {
	if [ -f ${ROOT}/usr/src/linux/include/linux/netfilter_ipv4/ipt_layer7.h ]
	then
		einfo 'attempting to unpatch l7-patch from kernel'
		which_patch
		cd ${T}
		unpack ${MY_P}.tar.gz
		EPATCH_SINGLE_MSG="removing previous patch" \
			EPATCH_OPTS="-F 3 -d ${ROOT}/usr/src/linux -R" epatch "${T}/${MY_P}/${PATCH}"
	fi
}
