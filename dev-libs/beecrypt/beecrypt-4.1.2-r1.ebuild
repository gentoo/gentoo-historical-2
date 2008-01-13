# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/beecrypt/beecrypt-4.1.2-r1.ebuild,v 1.22 2008/01/13 01:02:25 vapier Exp $

inherit flag-o-matic eutils multilib autotools java-pkg-opt-2

DESCRIPTION="general-purpose cryptography library"
HOMEPAGE="http://sourceforge.net/projects/beecrypt"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="java nocxx python threads"

COMMONDEPEND="python? ( >=dev-lang/python-2.2 )
	!<app-arch/rpm-4.2.1"

DEPEND="${COMMONDEPEND}
	java? ( >=virtual/jdk-1.4 )"

RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.4 )"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Set correct python libdir on multilib systems
	sed -i -e 's:get_python_lib():get_python_lib(1,0):' \
		configure.ac || die "sed failed"
	# let configure figure out libpaths, not a pokey build system
	sed -i \
		-e '/^libaltdir=/s:=.*:=$(libdir):' \
		$(find . -name Makefile.am) || die

	# upstream patches from CVS
	epatch "${FILESDIR}/${P}-python-Makefile-am.patch"
	epatch "${FILESDIR}/${P}-python-debug-py-c.patch"
	epatch "${FILESDIR}/${P}-build.patch"
	epatch "${FILESDIR}/${P}-gcc4.patch"
	epatch "${FILESDIR}/${P}-threads.patch"
	eautoreconf
}

src_compile() {
	local myarch=$(get-flag march)
	[[ -z ${myarch} ]] && myarch=${CHOST%%-*}
	[[ ${myarch} == "athlon64" || ${myarch} == "k8" || ${myarch} == "opteron" || ${myarch} == "athlon-fx" ]] && \
		[[ ${CHOST%%-*} != "x86_64" ]] && myarch=${CHOST%%-*}
	replace-flags pentium4m pentium4
	econf \
		$(use_enable threads) \
		$(use_with !nocxx cplusplus) \
		$(use_with java) \
		$(use_with python) \
		--with-arch=${myarch} \
		--libdir=/usr/$(get_libdir) \
		|| die
	emake || die "emake failed"
}

src_test() {
	export BEECRYPT_CONF_FILE=${T}/beecrypt-test.conf
	echo provider.1=${S}/c++/provider/.libs/base.so > ${BEECRYPT_CONF_FILE}
	make check || die "self test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	# Not needed
	rm -f "${D}"/usr/$(get_libdir)/python*/site-packages/_bc.*a
	dodoc BUGS README BENCHMARKS NEWS || die "dodoc failed"
}
