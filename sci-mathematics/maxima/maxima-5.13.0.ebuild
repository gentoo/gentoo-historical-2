# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/maxima/maxima-5.13.0.ebuild,v 1.3 2007/09/14 08:35:10 bicatali Exp $

inherit eutils elisp-common autotools

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 AECA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cmucl clisp sbcl gcl tetex emacs tk nls unicode"

# rlwrap is recommended for cmucl and sbcl
RDEPEND=">=sci-visualization/gnuplot-4.0
	x11-misc/xdg-utils
	tetex? ( virtual/tetex )
	emacs? ( virtual/emacs
		 tetex? ( || ( app-emacs/auctex app-xemacs/auctex ) ) )
	clisp? ( dev-lisp/clisp )
	gcl?   ( dev-lisp/gcl )
	sbcl?  ( dev-lisp/sbcl app-misc/rlwrap )
	cmucl? ( >=dev-lisp/cmucl-19a app-misc/rlwrap )
	!clisp? ( !gcl? ( !cmucl? ( dev-lisp/sbcl app-misc/rlwrap ) ) )
	tk? ( dev-lang/tk )"

DEPEND="${RDEPEND}
	sys-apps/texinfo"

LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

pkg_setup() {
	# Don't install in the main tree, as this may cause file collisions
	if use tetex; then
		local TEXMFPATH="$(kpsewhich -var-value=TEXMFSITE)"
		local TEXMFCONFIGFILE="$(kpsewhich texmf.cnf)"

		if [ -z "${TEXMFPATH}" ]; then
			eerror "You haven't defined the TEXMFSITE variable in your TeX config."
			eerror "Please do so in the file ${TEXMFCONFIGFILE:-/var/lib/texmf/web2c/texmf.cnf}"
			die "Define TEXMFSITE in TeX configuration!"
		else
			# go through the colon separated list of directories (maybe only one) provided in the variable
			# TEXMFPATH (generated from TEXMFSITE from TeX's config) and choose only the first entry.
			# All entries are separated by colons, even when defined with semi-colons, kpsewhich changes
			# the output to a generic format, so IFS has to be redefined.
			local IFS="${IFS}:"

			for strippedpath in ${TEXMFPATH}; do
				if [ -d ${strippedpath} ]; then
					MAXIMA_TEXMFDIR="${strippedpath}"
					break
				fi
			done

			# verify if an existing path was chosen to prevent from installing into the wrong directory
			if [ -z ${MAXIMA_TEXMFDIR} ]; then
				eerror "TEXMFSITE does not contain any existing directory."
				eerror "Please define an existing directory in your TeX config file"
				eerror "${TEXMFCONFIGFILE:-/var/lib/texmf/web2c/texmf.cnf} or create at least one of the there specified directories"
				die "TEXMFSITE variable did not contain an existing directory"
			fi
		fi
	fi

	if ! built_with_use -a sci-visualization/gnuplot gd; then
		elog "To benefit full plotting capability of maxima,"
		elog "enable the gd USE flag enabled for sci-visualization/gnuplot"
		elog "Then re-emerge maxima"
		epause 5
	fi

	# enable gcl if no other lisp selected
	if use sbcl || (! use cmucl && ! use clisp && ! use gcl ); then
		ENABLE_SBCL="--enable-sbcl"
	fi

	if use gcl; then
		einfo "Using gcl: it might break, recompile with another lisp, or use default (sbcl)."
		if ! built_with_use dev-lisp/gcl ansi; then
			eerror "GCL must be installed with ANSI."
			eerror "Try USE=\"ansi\" emerge gcl"
			die "This package needs gcl with USE=ansi"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	# use xdg-open to view ps, pdf
	epatch "${FILESDIR}"/${P}-xdg-utils.patch
}

src_compile() {
	eautoreconf

	# remove rmaxima if neither cmucl nor sbcl
	if !use sbcl && ! use cmucl && [[ -z ${ENABLE_SBCL} ]]; then
		sed -i \
			-e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' \
			src/Makefile.in || die "sed for rmaxima failed"
	fi

	local myconf=${ENABLE_SBCL}

	# remove xmaxima if no tk
	if use tk; then
		myconf="${myconf} --with-wish=wish"
	else
		myconf="${myconf} --with-wish=none"
		sed -i \
			-e '/^SUBDIRS/s/xmaxima//' \
			interfaces/Makefile.in || die "sed for tk failed"
	fi

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf \
		$(use_enable cmucl) \
		$(use_enable clisp) \
		$(use_enable gcl) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png

	use emacs && \
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el

	if use tetex; then
		insinto "${MAXIMA_TEXMFDIR}"/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING ChangeLog-${PV} README README.lisps
	dodir /usr/share/doc
	dosym /usr/share/${PN}/${PV}/doc /usr/share/doc/${PF}
}

pkg_preinst() {
	# all lisps do not bunzip2 info files on the fly
	for infofile in $(ls ${D}/usr/share/info/*.bz2); do
		bunzip2 "${infofile}"
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use tetex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
