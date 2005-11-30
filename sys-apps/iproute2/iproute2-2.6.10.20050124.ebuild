# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/iproute2/iproute2-2.6.10.20050124.ebuild,v 1.1 2005/02/10 02:48:01 vapier Exp $

inherit eutils toolchain-funcs

MY_PV=${PV%.*}
SNAP=${PV##*.}
SNAP=ss${SNAP:2}
DESCRIPTION="kernel routing and traffic control utilities"
HOMEPAGE="http://developer.osdl.org/dev/iproute2/"
SRC_URI="http://developer.osdl.org/dev/iproute2/download/${PN}-${MY_PV}-${SNAP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="atm minimal"

RDEPEND="virtual/libc
	!minimal? ( sys-libs/db )
	atm? ( net-dialup/linux-atm )"
DEPEND="${RDEPEND}
	>=virtual/os-headers-2.4.21
	>=sys-apps/sed-4"

S=${WORKDIR}/${PN}-${SNAP/ss}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:-O2:${CFLAGS}:" Makefile || die "sed Makefile failed"
	#68948 - esfq/wrr patches
	epatch \
		${FILESDIR}/2.6.9.20041106-esfq.patch \
		${FILESDIR}/2.6.9.20041019-wrr.patch

	# Multilib fixes
	sed -i "s:/usr/lib/tc:/usr/$(get_libdir)/tc:g" \
		tc/Makefile tc/tc.c tc/q_netem.c
}

src_compile() {
	echo -n 'TC_CONFIG_ATM:=' > Config
	use atm \
		&& echo 'y' >> Config \
		|| echo 'n' >> Config

	local SUBDIRS="lib ip tc misc"
	use minimal && SUBDIRS="lib tc"
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		SUBDIRS="${SUBDIRS}" \
		|| die "make"
}

src_install() {
	if use minimal; then
		into /
		dosbin tc/tc || die "minimal"
		return 0
	fi

	dodir /usr/share/man/man3
	make \
		DESTDIR="${D}" \
		SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/${PF} \
		install \
		|| die "make install failed"
}
