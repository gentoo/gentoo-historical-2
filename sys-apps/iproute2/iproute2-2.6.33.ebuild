# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/iproute2/iproute2-2.6.33.ebuild,v 1.1 2010/03/07 00:18:59 vapier Exp $

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git"
	inherit git
	SRC_URI=""
	#KEYWORDS=""
else
	if [[ ${PV} == *.*.*.* ]] ; then
		MY_PV=${PV%.*}-${PV##*.}
	else
		MY_PV=${PV}
	fi
	MY_P="${PN}-${MY_PV}"
	SRC_URI="http://developer.osdl.org/dev/iproute2/download/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="kernel routing and traffic control utilities"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2"

LICENSE="GPL-2"
SLOT="0"
IUSE="atm berkdb minimal"

RDEPEND="!net-misc/arpd
	!minimal? ( berkdb? ( sys-libs/db ) )
	atm? ( net-dialup/linux-atm )"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.7 )
	>=virtual/os-headers-2.6.27"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	sed -i "s:-O2:${CFLAGS} ${CPPFLAGS}:" Makefile || die "sed Makefile failed"

	# build against system headers
	rm -r include/netinet #include/linux include/ip{,6}tables{,_common}.h include/libiptc

	epatch "${FILESDIR}"/${PN}-2.6.29.1-hfsc.patch #291907

	epatch_user

	# don't build arpd if USE=-berkdb #81660
	use berkdb || sed -i '/^TARGETS=/s: arpd : :' misc/Makefile
	# Multilib fixes
	sed -i "s:/usr/lib:/usr/$(get_libdir):g" \
		netem/Makefile tc/{Makefile,tc.c,q_netem.c,m_ipt.c} || die
	sed -i "s:/lib/tc:$(get_libdir)/tc:g" tc/Makefile || die
}

src_configure() {
	echo -n 'TC_CONFIG_ATM:=' > Config
	use atm \
		&& echo 'y' >> Config \
		|| echo 'n' >> Config

	use minimal && sed -i -e '/^SUBDIRS=/s:=.*:=lib tc:' Makefile

	# Use correct iptables dir, #144265 #293709
	append-cppflags -DIPT_LIB_DIR=\\\"`$(tc-getPKG_CONFIG) xtables --variable=xtlibdir`\\\"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		|| die "make failed"
}

src_install() {
	if use minimal ; then
		into /
		dosbin tc/tc || die "minimal"
		return 0
	fi

	emake \
		DESTDIR="${D}" \
		SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/${PF} \
		MANDIR=/usr/share/man \
		install \
		|| die "make install failed"
	prepalldocs
	if use berkdb ; then
		dodir /var/lib/arpd
		# bug 47482, arpd doesn't need to be in /sbin
		dodir /usr/sbin
		mv "${D}"/sbin/arpd "${D}"/usr/sbin/
	fi
}
