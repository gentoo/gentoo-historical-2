# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/v8/v8-3.6.5.1.ebuild,v 1.4 2011/10/12 22:39:01 floppym Exp $

EAPI="4"

inherit eutils multilib pax-utils toolchain-funcs

GYP_REV="1066"

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentoo.org/~floppym/distfiles/${P}.tar.gz
	http://dev.gentoo.org/~floppym/distfiles/gyp-${GYP_REV}.tar.xz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos ~x86-macos"
IUSE="readline"

# Avoid using python eclass since we do not need python RDEPEND
DEPEND="|| ( dev-lang/python:2.6 dev-lang/python:2.7 )"
RDEPEND="readline? ( >=sys-libs/readline-6.1 )"

src_unpack() {
	unpack ${A}
	mv gyp-${GYP_REV} ${P}/build/gyp || die
}

src_prepare() {
	# Stop -Werror from breaking the build.
	sed -i -e "s/-Werror//" build/standalone.gypi || die

	# Respect the user's CFLAGS, including the optimization level.
	epatch "${FILESDIR}/v8-gyp-cflags-r0.patch"
}

src_compile() {
	# Make /usr/bin/python (wrapper) call python2
	export EPYTHON=python2

	tc-export AR CC CXX RANLIB
	export LINK="${CXX}"

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*) myarch=ia32 ;;
		x86_64-*)
			if [[ $ABI = x86 ]] ; then
				myarch=ia32
			else
				myarch=x64
			fi ;;
		arm*-*) myarch=arm ;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac
	mytarget=${myarch}.release

	console=""
	if use readline; then
		console="readline";
	fi
	if [[ ${PV} == "9999" ]]; then
		soname_version="${PV}-${ESVN_WC_REVISION}"
	else
		soname_version="${PV}"
	fi
	emake V=1 library=shared werror=no console=${console} soname_version=${soname_version} ${mytarget} || die
	pax-mark m out/${mytarget}/{cctest,d8,shell} || die
}

src_test() {
	tools/test-wrapper-gypbuild.py \
		--arch-and-mode=${mytarget} \
		--no-presubmit \
		--progress=dots || die
}

src_install() {
	insinto /usr
	doins -r include

	dobin out/${mytarget}/d8

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8-${soname_version}$(get_libname) \
			out/${mytarget}/lib.target/libv8-${soname_version}$(get_libname) || die
	fi

	dolib out/${mytarget}/lib.target/libv8-${soname_version}$(get_libname)
	dosym libv8-${soname_version}$(get_libname) /usr/$(get_libdir)/libv8$(get_libname)

	dodoc AUTHORS ChangeLog
}
