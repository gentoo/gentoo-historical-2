# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/gcl/gcl-2.6.6.ebuild,v 1.3 2005/04/22 09:46:11 blubb Exp $

inherit elisp-common flag-o-matic

DESCRIPTION="GNU Common Lisp"
HOMEPAGE="http://www.gnu.org/software/gcl/gcl.html"
SRC_URI="ftp://ftp.gnu.org/gnu/gcl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="emacs readline debug X tcltk custreloc dlopen gprof doc ansi"

DEPEND=">=app-text/texi2html-1.64
	emacs? ( virtual/emacs )
	X? ( virtual/x11 )
	readline? ( sys-libs/readline )
	>=dev-libs/gmp-4.1
	doc? ( virtual/tetex )
	tcltk? ( dev-lang/tk )"

SANDBOX_DISABLED="1"

src_unpack() {
	unpack ${A}
	sed -e "s/gcl-doc/${PF}/g" ${S}/info/makefile > ${T}/makefile
	mv ${T}/makefile ${S}/info/makefile
}

src_compile() {
	local myconfig=""

	# Hardened gcc may automatically use PIE building, which does not
	# work for this package so far

	filter-flags "-fPIC"

	# -fomit-frame-pointer cannot be used with gprof

	if use gprof; then
		filter-flags "-fomit-frame-pointer"
	fi

	# Unfortunately, we need to override any relocation choices below
	# while upstream doesn't work with system BFD.	SuSE has the same
	# problem apparently.

	if false; then

	# Linking options are enumerated at
	# http://www.gnu.org/software/gcl/RELEASE-2.6.2.html

	local dlopen_config="
		--disable-custreloc
		--enable-dlopen
		--disable-dynsysbfd
		--disable-statsysbfd";

	local bfd_config="
		--disable-custreloc
		--disable-dlopen
		--enable-dynsysbfd
		--disable-statsysbfd";

	local custreloc_config="
		--enable-custreloc
		--disable-dlopen
		--disable-dynsysbfd
		--disable-statsysbfd";

	if use custreloc; then
		case "${ARCH}" in
			x86 | sparc)
				myconfig="${myconfig} ${custreloc_config}";;
			*)
				ewarn "--enable-custreloc is not supported on your architecture (${ARCH})."
				ewarn "Using --enable-dlopen instead."
				myconfig="${myconfig} ${dlopen_config}"

		esac
	elif use dlopen; then
		myconfig="${myconfig} ${dlopen_config}"
	else
		case "${ARCH}" in
			x86 | sparc | ppc | amd64 | s390)
				myconfig="${myconfig} ${bfd_config}";;
			*)
				ewarn "BFD is not supported on your architecture (${ARCH})."
				ewarn "Using --enable-dlopen instead."
				myconfig="${myconfig} ${dlopen_config}";;
		esac
	fi

	else
		myconfig="${myconfig} --enable-locbfd --disable-dynsysbfd --disable-statsysbfd"
	fi

	if use tcltk; then
		myconfig="${myconfig}
		--enable-tkconfig=/usr/lib
		--enable-tclconfig=/usr/lib"
	fi

	myconfig="${myconfig}
		--enable-dynsysgmp
		`use_enable readline readline`
		`use_with X x`
		`use_enable debug debug`
		`use_enable gprof gprof`
		`use_enable ansi ansi`
		--enable-xdr=no
		--enable-infodir=/usr/share/info
		--enable-emacsdir=/usr/share/emacs/site-lisp/gcl"

	einfo "Configuring with the following:
${myconfig}"
	econf ${myconfig} || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die

	rm -rf ${D}/usr/lib/${P}/info
	mv ${D}/default.el elisp/

	if use emacs; then
		mv elisp/add-default.el ${T}/50gcl-gentoo.el
		elisp-site-file-install ${T}/50gcl-gentoo.el
		elisp-install ${PN} elisp/*
		fperms 0644 /usr/share/emacs/site-lisp/gcl/*
	else
		rm -rf ${D}/usr/share/emacs
	fi

	dosed /usr/bin/gcl
	fperms 0755 /usr/bin/gcl

	# fix the GCL_TK_DIR=/var/tmp/portage/${P}/image//
	dosed /usr/lib/${P}/gcl-tk/gcltksrv
	fperms 0755 /usr/lib/${P}/gcl-tk/gcltksrv

	#repair gcl.exe symlink
	#rm ${D}/usr/bin/gcl.exe
	dosym ../lib/${P}/unixport/saved_gcl /usr/bin/gcl.exe

	dodoc readme* RELEASE* ChangeLog* doc/*

	find ${D}/usr/lib/gcl-2.6.5/ -type f \( -perm 640 -o -perm 750 \) -exec chmod 0644 '{}' \;
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
