# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/v8/v8-9999.ebuild,v 1.13 2011/10/12 18:18:48 phajdan.jr Exp $

EAPI="2"

inherit eutils multilib pax-utils subversion toolchain-funcs

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
ESVN_REPO_URI="http://v8.googlecode.com/svn/trunk"
LICENSE="BSD"

SLOT="0"
KEYWORDS=""
IUSE="readline"

RDEPEND="readline? ( >=sys-libs/readline-6.1 )"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	make dependencies || die
}

src_compile() {
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
	doins -r include || die

	dobin out/${mytarget}/d8 || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8-${soname_version}$(get_libname) \
			out/${mytarget}/lib.target/libv8-${soname_version}$(get_libname) || die
	fi

	dolib out/${mytarget}/lib.target/libv8-${soname_version}$(get_libname) || die
	dosym libv8-${soname_version}$(get_libname) /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}
