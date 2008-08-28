# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/gambit/gambit-4.1.1.ebuild,v 1.2 2008/08/28 17:41:15 ulm Exp $

inherit eutils elisp-common check-reqs autotools multilib

MY_PN=gambc
MY_PV=${PV//./_}
MY_P=${MY_PN}-v${MY_PV}

DESCRIPTION="Gambit-C is a native Scheme to C compiler and interpreter."
HOMEPAGE="http://www.iro.umontreal.ca/~gambit/"
SRC_URI="http://www.iro.umontreal.ca/~gambit/download/gambit/v${PV%.*}/source/${MY_P}.tgz"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="emacs? ( virtual/emacs )"

SITEFILE="50gambit-gentoo.el"

S=${WORKDIR}/${MY_P}

IUSE="big-iron emacs static"

pkg_setup() {
	if ! use big-iron; then
		ewarn "NOT compiling each Scheme module as a single C function"
		ewarn "NOT using gcc specific optimizations"
#		ewarn "NOT compiling syntax-case macro system"
		ewarn "approximately 0.5GB ram will be needed"
		ewarn "if you experience thrashing, try disabling parallel building or setting -O1"
		# need this much memory in MBytes (does *not* check swap)
		CHECKREQS_MEMORY="768" check_reqs
	else
		ewarn "compiling each Scheme module as a single C function"
		ewarn "using gcc specific optimizations"
#		ewarn "compiling syntax-case macro system"
		ewarn "approximately 2GB ram will be needed instead of 0.5GB"
		ewarn "this will cause heavy thrashing of your system"
		ewarn "and may cause your compiler to crash when it runs out of memory"
		ewarn "unless your system is BIG IRON"
		# need this much memory in MBytes (does *not* check swap)
		CHECKREQS_MEMORY="2560"	check_reqs
	fi
}

src_unpack() {
	unpack ${A}; cd "${S}"
#	cp configure.ac configure.ac.old
	sed -e 's:PACKAGE_SUBDIR="/$PACKAGE_VERSION"::' \
		-e 's:#PACKAGE_SUBDIR="":PACKAGE_SUBDIR="":' -i configure.ac
	#don't force -O1
	sed 's:$DASH_O1::' -i configure.ac
	eautoreconf
#	diff -u configure.ac.old configure.ac
}

src_compile() {
	econf $(use_enable !static shared) $(use_enable big-iron single-host) $(use_enable big-iron gcc-opts)

	emake || die "emake failed"

	if use emacs; then
		elisp-compile misc/*.el || die "elisp-compile failed"
	fi

	#workaround
	mv gsi/libgambcgsi.so gsc/libgambcgsc.so lib/
}

src_install() {
	einstall docdir="${D}"/usr/share/doc/${PF} || die "einstall failed"

	rm "${D}"/usr/current

	mv "${D}"/usr/syntax-case.scm "${D}"/usr/$(get_libdir)

	# rename the /usr/bin/gsc to avoid collision with gsc from ghostscript
	mv "${D}"/usr/bin/gsc "${D}"/usr/bin/gsc-gambit

	# remove emacs/site-lisp/gambit.el
	rm -r "${D}"/usr/share/emacs
	if use emacs; then
		elisp-install ${PN} misc/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	dodoc INSTALL.txt README
	insinto /usr/share/doc/${PF}
	doins -r examples

	# create some more explicit names
	dosym gsc-gambit usr/bin/gambit-compiler
	dosym gsi usr/bin/gambit-interpreter

	echo "GAMBCOPT=\"=/usr/\"" > "${T}"/50gambit && doenvd "${T}"/50gambit
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
