# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/sbcl/sbcl-1.0.6-r1.ebuild,v 1.6 2007/09/27 11:57:09 hkbst Exp $

inherit common-lisp-common-3 eutils flag-o-matic

#same order as http://www.sbcl.org/platform-table.html
BV_X86=1.0.7
BV_AMD64=1.0.7
BV_PPC=1.0
BV_SPARC=0.9.17
BV_ALPHA=0.9.12
BV_MIPS=0.9.12
BV_MIPSEL=0.9.12

# BV_PPC_MACOS=0.9.11a

DESCRIPTION="Steel Bank Common Lisp (SBCL) is an implementation of ANSI Common Lisp."
HOMEPAGE="http://sbcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/sbcl/${P}-source.tar.bz2
	amd64? ( mirror://sourceforge/sbcl/${PN}-${BV_AMD64}-x86-64-linux-binary.tar.bz2 )
	x86? ( mirror://sourceforge/sbcl/${PN}-${BV_X86}-x86-linux-binary.tar.bz2 )
	ppc? ( mirror://sourceforge/sbcl/${PN}-${BV_PPC}-powerpc-linux-binary.tar.bz2 )
	sparc? ( mirror://sourceforge/sbcl/${PN}-${BV_SPARC}-sparc-linux-binary.tar.bz2 )
	alpha? ( mirror://sourceforge/sbcl/${PN}-${BV_ALPHA}-alpha-linux-binary.tar.bz2 )
	mips? ( !cobalt? ( mirror://sourceforge/sbcl/${PN}-${BV_MIPS}-mips-linux-binary.tar.bz2 ) )
	mips? ( cobalt? ( mirror://sourceforge/sbcl/${PN}-${BV_MIPSEL}-mipsel-linux-binary.tar.bz2 ) )
"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="ldb source threads unicode doc"

DEPEND="doc? ( sys-apps/texinfo )"

PROVIDE="virtual/commonlisp"

sbcl_elog() {
	local method
	case $# in
		0) method=elog;;
		1) method=$1;;
		*) die "Invalid number of arguments to scbl_elog"
	esac
	$method ""; while read line; do $method "${line}"; done; $method ""
}

pkg_setup() {
	if built_with_use sys-devel/gcc hardened && gcc-config -c |grep -qv vanilla; then
		sbcl_elog eerror <<'EOF'
So-called "hardened" compiler features are incompatible with SBCL. You
must use gcc-config to select a profile with non-hardened features
(the "vanilla" profile) and "source /etc/profile" before continuing.
EOF
		die
	fi
	if ! built_with_use sys-libs/glibc nptl && (use x86 || use amd64); then
		sbcl_elog eerror <<'EOF'
Building SBCL without NPTL support on at least x86 and amd64
architectures is not a supported configuration in Gentoo.  Please
refer to Bug #119016 for more information.
EOF
		die
	fi
	if use ppc && use ldb; then
		sbcl_elog ewarn <<'EOF'
Building SBCL on PPC with LDB support is not a supported configuration
in Gentoo.	Please refer to Bug #121830 for more information.
Continuing with LDB support disabled.
EOF
	fi
}

src_unpack() {
	local a
	if use ppc; then
		a="${PN}-${BV_PPC}-powerpc-linux-binary.tar.bz2"
	else
		for a in ${A}; do [[ $a == *binary* ]] && break; done
	fi
	unpack $a
	mv ${PN}* sbcl-binary || die
	unpack ${P}-source.tar.bz2
	pushd ${S}
	epatch ${FILESDIR}/disable-tests-gentoo.patch || die
	epatch ${FILESDIR}/vanilla-module-install-source-gentoo.patch || die
	popd
	sed -i "s,/lib,/$(get_libdir),g" ${S}/install.sh
	sed -i "s,/usr/local/lib,/usr/$(get_libdir),g" \
		${S}/src/runtime/runtime.c # #define SBCL_HOME ...
	cat >${S}/customize-target-features.lisp <<'EOF'
(lambda (list)
  (flet ((enable (x)
		   (pushnew x list))
		 (disable (x)
		   (setf list (remove x list))))
EOF
	if use x86 || use amd64; then
		use threads && echo '(enable :sb-thread)' \
			>>${S}/customize-target-features.lisp
	fi
	if use ppc && use ldb; then
		sbcl_elog ewarn <<'EOF'
Excluding LDB support for ppc.
EOF
	else
		use ldb \
			&& echo '(enable :sb-ldb)' \
			>>${S}/customize-target-features.lisp
	fi
	echo '(disable :sb-test)' >>${S}/customize-target-features.lisp
	! use unicode \
		&& echo '(disable :sb-unicode)' \
		>>${S}/customize-target-features.lisp
	cat >>${S}/customize-target-features.lisp <<'EOF'
	)
  list)
EOF
	cat ${S}/customize-target-features.lisp

	find ${S} -type f -name .cvsignore -print0 | xargs -0 rm -f
	find ${S} -depth -type d -name CVS -print0 | xargs -0 rm -rf
	find ${S} -type f -name \*.c -print0 | xargs -0 chmod 644
}

src_compile() {
	local bindir="${WORKDIR}/sbcl-binary"

	filter-ldflags -Wl,--as-needed --as-needed # see Bug #132992

	LANG=C PATH=${bindir}/src/runtime:${PATH} SBCL_HOME=${bindir}/output GNUMAKE=make \
		./make.sh 'sbcl
			--sysinit /dev/null
			--userinit /dev/null
			--disable-debugger
			--core ${bindir}/output/sbcl.core' \
				|| die
	if use doc; then
			cd ${S}/doc/manual
			LANG=C make info html || die
	fi
}

src_install() {
	unset SBCL_HOME
	dodir /etc/
	cat >${D}/etc/sbclrc <<EOF
;;; The following is required if you want source location functions to
;;; work in SLIME, for example.

(setf (logical-pathname-translations "SYS")
	'(("SYS:SRC;**;*.*.*" #p"/usr/$(get_libdir)/sbcl/src/**/*.*")
	  ("SYS:CONTRIB;**;*.*.*" #p"/usr/$(get_libdir)/sbcl/**/*.*")))
EOF
	dodir /usr/share/man
	dodir /usr/share/doc/${PF}
	INSTALL_ROOT=${D}/usr DOC_DIR=${D}/usr/share/doc/${PF} sh install.sh || die

	doman doc/sbcl-asdf-install.1
	dodoc BUGS COPYING CREDITS INSTALL NEWS OPTIMIZATIONS PRINCIPLES README STYLE SUPPORT TLA TODO
	if use doc; then
		dohtml doc/html/*
		doinfo ${S}/doc/manual/*.info*
	fi

	if ! use nosource; then
		# install the SBCL source
		cp -pPR ${S}/src ${D}/usr/$(get_libdir)/sbcl
		find ${D}/usr/$(get_libdir)/sbcl/src -type f -name \*.fasl -print0 | xargs -0 rm -f
	fi

	impl-save-timestamp-hack sbcl
}

pkg_postinst() {
	standard-impl-postinst sbcl
}

pkg_postrm() {
	standard-impl-postrm sbcl /usr/bin/sbcl
}
