# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/sbcl/sbcl-0.8.21-r1.ebuild,v 1.1 2005/04/25 05:55:06 mkennedy Exp $

inherit common-lisp-common-2 eutils

SBCL_AF_PV=2004-10-22

BV_X86=0.8.1
BV_PPC=0.8.15
BV_SPARC=0.7.13
BV_MIPS=0.7.10
BV_AMD64=0.8.19

DESCRIPTION="Steel Bank Common Lisp (SBCL) is an implementation of ANSI Common Lisp."
HOMEPAGE="http://sbcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/sbcl/${P}-source.tar.bz2
	mirror://sourceforge/sbcl/${P}-html.tar.bz2
	x86? ( mirror://sourceforge/sbcl/${PN}-${BV_X86}-x86-linux-binary.tar.bz2 )
	ppc? ( mirror://sourceforge/sbcl/${PN}-${BV_PPC}-powerpc-linux-binary.tar.bz2 )
	sparc? ( mirror://sourceforge/sbcl/${PN}-${BV_SPARC}-sparc-linux-binary.tar.bz2 )
	mips? ( mirror://sourceforge/sbcl/${PN}-${BV_MIPS}-mips-linux-binary.tar.gz )
	amd64? ( mirror://sourceforge/sbcl/${PN}-${BV_AMD64}-x86-64-linux-binary.tar.bz2 )
	callbacks? ( http://pinhead.music.uiuc.edu/~hkt/sbcl-af-${SBCL_AF_PV}.tgz )"

LICENSE="MIT"
SLOT="0"

KEYWORDS="x86 ~ppc ~sparc ~mips ~amd64"
IUSE="threads doc nosource unicode ldb callbacks"

DEPEND="=dev-lisp/common-lisp-controller-4*
	>=dev-lisp/cl-asdf-1.84
	sys-apps/texinfo
	doc? ( virtual/tetex )"

PROVIDE="virtual/commonlisp"

MY_WORK=${S}/my_work

pkg_setup() {
	if gcc-config -c |grep hardened; then
		while read line; do einfo "${line}"; done <<EOF

So-called "hardened" compiler features are incompatible with SBCL.	You must use
gcc-config to select a profile with non-hardened features and "source
/etc/profile" before continuing.

EOF
	die
	fi
}

src_unpack() {
	mkdir -p ${MY_WORK} && cp --verbose ${FILESDIR}/${PV}/* ${MY_WORK}
	sed -i "s,/usr/lib,/usr/$(get_libdir),g" ${MY_WORK}/*

	if use x86; then
		unpack ${PN}-${BV_X86}-x86-linux-binary.tar.bz2
		mv ${PN}-${BV_X86} x86-binary
	elif use ppc; then
		unpack ${PN}-${BV_PPC}-powerpc-linux-binary.tar.bz2
		mv ${PN}-${BV_PPC}-powerpc-linux ppc-binary
	elif use sparc; then
		unpack ${PN}-${BV_SPARC}-sparc-linux-binary.tar.bz2
		echo mv ${PN}-${BV_SPARC} sparc-binary || die
		mv ${PN}-${BV_SPARC} sparc-binary || die
	elif use mips; then
		unpack ${PN}-${BV_MIPS}-mips-linux-binary.tar.gz
		mv ${PN}-${BV_MIPS}-mips-linux mips-binary
	elif use amd64; then
		unpack ${PN}-${BV_AMD64}-x86-64-linux-binary.tar.bz2
		mv ${PN}-${BV_AMD64}-x86-64-linux x86-64-binary
	fi

	unpack ${P}-source.tar.bz2
	epatch ${MY_WORK}/sbcl-gentoo.patch
	epatch ${MY_WORK}/sbcl-no-tests-gentoo.patch

	cp ${MY_WORK}/customize-target-features.lisp-prefix \
		${S}/customize-target-features.lisp
	use x86 && use threads \
		&& echo '(enable :sb-thread)' \
		>>${S}/customize-target-features.lisp
	use ldb \
		&& echo '(enable :sb-ldb)' \
		>>${S}/customize-target-features.lisp
	use x86 \
		&& echo '(enable :sb-futex)' \
		>>${S}/customize-target-features.lisp
	echo '(disable :sb-test)' >>${S}/customize-target-features.lisp
	! use unicode \
		&& echo '(disable :sb-unicode)' \
		>>${S}/customize-target-features.lisp
	cat ${MY_WORK}/customize-target-features.lisp-suffix \
		>>${S}/customize-target-features.lisp
	find ${S} -type f -name .cvsignore -exec rm -f '{}' \;
	find ${S} -depth -type d -name CVS	-exec rm -rf '{}' \;
	find ${S} -type f -name \*.c -exec chmod 644 '{}' \;

	if use callbacks; then
		einfo "You have specified the \"callbacks\" USE flag.  Callbacks may only work for x86."
		einfo "Please refer to README.Gentoo for more information."
		unpack sbcl-af-${SBCL_AF_PV}.tgz
	fi
}

src_compile() {
	local bindir=""

	if use x86; then
		bindir=../x86-binary
	elif use ppc; then
		bindir=../ppc-binary
	elif use sparc; then
		bindir=../sparc-binary
	elif use mips; then
		bindir=../mips-binary
	elif use amd64; then
		bindir=../x86-64-binary
	fi

	PATH=${bindir}/src/runtime:${PATH} SBCL_HOME=${bindir}/output GNUMAKE=make \
		./make.sh 'sbcl
			--sysinit /dev/null
			--userinit /dev/null
			--no-debugger
			--core ${bindir}/output/sbcl.core' \
				|| die
	cd ${S}/doc/manual
	make info
	use doc && make ps pdf
}

src_install() {
	unset SBCL_HOME

	insinto /etc/
	doins ${MY_WORK}/sbclrc	# Gentoo specific (from Debian)

	exeinto /usr/$(get_libdir)/common-lisp/bin
	doexe ${MY_WORK}/sbcl.sh	# Gentoo specific (from Debian)

	dodir /usr/share/man
	dodir /usr/share/doc/${PF}
	INSTALL_ROOT=${D}/usr DOC_DIR=${D}/usr/share/doc/${PF} sh install.sh || die
	mv ${D}/usr/$(get_libdir)/sbcl/sbcl.core ${D}/usr/$(get_libdir)/sbcl/sbcl-dist.core || die

	insinto /usr/$(get_libdir)/sbcl
	doins ${MY_WORK}/install-clc.lisp	# Gentoo specific (from Debian)

	doman doc/sbcl-asdf-install.1

	dodoc BUGS COPYING CREDITS INSTALL NEWS OPTIMIZATIONS PRINCIPLES README STYLE SUPPORT TLA TODO
	dodoc ${MY_WORK}/README.Gentoo
	dohtml doc/html/*

	doinfo ${S}/doc/manual/*.info
	use doc && dodoc ${S}/doc/manual/*.{pdf,ps}

	keepdir /usr/$(get_libdir)/common-lisp/sbcl

	if ! use nosource; then
		# install the SBCL source
		find ${S}/src -type f -name \*.fasl |xargs rm -f
		mv ${S}/src ${D}/usr/$(get_libdir)/sbcl/
	fi

	impl-save-timestamp-hack sbcl || die
}

pkg_postinst() {
	standard-impl-postinst sbcl
	if use callbacks; then
		mv /usr/$(get_libdir)/sbcl/sbcl.core /usr/$(get_libdir)/sbcl/sbcl-nocallbacks.core || die
		pushd ${WORKDIR}/sbcl-af
		sbcl --core /usr/$(get_libdir)/sbcl/sbcl-nocallbacks.core \
			--load 'system' \
			--eval "(sb-ext:save-lisp-and-die \"/usr/$(get_libdir)/sbcl/sbcl.core\")" || die
		popd
	fi
# Image Summary
# -------------
# /usr/$(get_libdir)/sbcl/sbcl-dist.core		  - Plain SBCL image
# /usr/$(get_libdir)/sbcl/sbcl-nocallbacks.core - CLC (Common Lisp Controller) image
# /usr/$(get_libdir)/sbcl/sbcl.core			  - CLC image w/ callbacks support
}

pkg_postrm() {
	standard-impl-postrm sbcl /usr/bin/sbcl
	if [ ! -x /usr/bin/sbcl ]; then
		rm -rf /usr/$(get_libdir)/sbcl/ || die
	fi
}
