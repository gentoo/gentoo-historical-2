# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/portmap/portmap-5b-r9.ebuild,v 1.12 2005/02/07 19:46:40 corsair Exp $

inherit eutils flag-o-matic toolchain-funcs

MY_P="${PN}_${PV}eta"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Netkit - portmapper"
HOMEPAGE="ftp://ftp.porcupine.org/pub/security/index.html"
SRC_URI="ftp://ftp.porcupine.org/pub/security/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="selinux tcpd"

DEPEND="virtual/libc
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r7 )
	>=sys-apps/portage-2.0.51"
RDEPEND="selinux? ( sec-policy/selinux-portmap )"

pkg_setup() {
	enewgroup rpc 111
	enewuser rpc 111 /bin/false /dev/null rpc
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}_5beta.dif

	# Redhat patches
	epatch ${FILESDIR}/${PN}-4.0-malloc.patch
	epatch ${FILESDIR}/${PN}-4.0-cleanup.patch
	epatch ${FILESDIR}/${PN}-4.0-rpc_user.patch
	epatch ${FILESDIR}/${PN}-4.0-sigpipe.patch

	# Should include errno.h, and not define as external.  Fix
	# relocation error and build problem with glibc-2.3.2 cvs ...
	# <azarah@gentoo.org> (31 Dec 2002).
	epatch ${FILESDIR}/${P}-include-errno_h.patch

	# Patch to listen on loopback only #65199
	epatch ${FILESDIR}/${P}-loopback-only.patch

	# Make tcp wrapper checks easier
	epatch ${FILESDIR}/${P}-optional-tcpd.patch
}

src_compile() {
	local tcpd=""
	use tcpd \
		&& tcpd="-lwrap" \
		&& append-flags -DHOSTS_ACCESS

	emake \
		CC="$(tc-getCC)" \
		O="${CFLAGS}" \
		WRAP_LIB="${tcpd}" \
		|| die
}

src_install() {
	into /
	dosbin portmap || die "portmap"
	into /usr
	dosbin pmap_dump pmap_set || die "pmap"

	doman portmap.8 pmap_dump.8 pmap_set.8
	dodoc BLURB CHANGES README

	newinitd ${FILESDIR}/portmap.rc6 portmap
	newconfd ${FILESDIR}/portmap.confd portmap
}
