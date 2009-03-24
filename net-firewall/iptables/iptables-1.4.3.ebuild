# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/iptables/iptables-1.4.3.ebuild,v 1.1 2009/03/24 08:12:31 pva Exp $

inherit eutils toolchain-funcs linux-info

L7_PV=2.21
L7_P=netfilter-layer7-v${L7_PV}

DESCRIPTION="Linux kernel (2.4+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://www.iptables.org/"
SRC_URI="http://iptables.org/projects/iptables/files/${P}.tar.bz2
	l7filter? ( mirror://sourceforge/l7-filter/${L7_P}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="l7filter"

DEPEND="virtual/os-headers"
RDEPEND=""

pkg_setup() {
	if use l7filter ; then
		ewarn "WARNING: 3rd party extensions has been enabled."
		ewarn "This means that iptables will use your currently installed"
		ewarn "kernel in ${KERNEL_DIR} as headers for iptables."
		linux-info_pkg_setup

		if kernel_is lt 2 6 20 ; then
			eerror "Currently there is no l7-filter patch available for iptables-1.4.x"
			eerror "and kernel version before 2.6.20."
			eerror "If you need to compile iptables 1.4.x against Linux 2.6.19.x"
			eerror "or earlier, with l7-filter patch, please, report upstream."
			die "No patch available."
		fi

		[[ ! -f ${KERNEL_DIR}/include/linux/netfilter/xt_layer7.h ]] && \
			die "For layer 7 support emerge net-misc/l7-filter-${L7_PV} before this."
	fi
}

src_unpack() {
	unpack ${P}.tar.bz2
	use l7filter && unpack ${L7_P}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.4.2-no-ldconfig.patch
	epatch "${FILESDIR}"/${PN}-1.4.2-hashlimit.patch #254496
	sed -e 's:\<\(LOAD_MUST_SUCCEED\)\>:XTF_\1:' -i xtables.c
	epatch "${FILESDIR}"/${P}-as-needed.patch

	local check base=${PORTAGE_CONFIGROOT}/etc/portage/patches
	for check in {${CATEGORY}/${PF},${CATEGORY}/${P},${CATEGORY}/${PN}}; do
		EPATCH_SOURCE=${base}/${CTARGET}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${CHOST}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${check}
		if [[ -d ${EPATCH_SOURCE} ]] ; then
			EPATCH_SUFFIX="patch"
			EPATCH_FORCE="yes" \
			EPATCH_MULTI_MSG="Applying user patches from ${EPATCH_SOURCE} ..." \
			epatch
			break
		fi
	done

	if use l7filter ; then
		cp "${WORKDIR}/${L7_P}/iptables-1.4.1.1-for-kernel-2.6.20forward"/* extensions \
			|| die "Failed to copy l7filter sources"
	fi
}

src_compile() {
	econf \
		--sbindir=/sbin \
		--libexecdir=/$(get_libdir) \
		--enable-devel \
		--enable-libipq \
		--enable-shared \
		--enable-static \
		$(use_with l7filter kernel ${KERNEL_DIR})
	emake V=1 || die
}

src_install() {
	emake install DESTDIR="${D}" || die

	insinto /usr/include
	doins include/iptables.h include/ip6tables.h || die

	keepdir /var/lib/iptables
	newinitd "${FILESDIR}"/${PN}-1.3.2.init iptables || die
	newconfd "${FILESDIR}"/${PN}-1.3.2.confd iptables || die
	keepdir /var/lib/ip6tables
	newinitd "${FILESDIR}"/iptables-1.3.2.init ip6tables || die
	newconfd "${FILESDIR}"/ip6tables-1.3.2.confd ip6tables || die
}
