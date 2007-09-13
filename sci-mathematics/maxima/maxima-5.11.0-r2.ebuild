# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/maxima/maxima-5.11.0-r2.ebuild,v 1.4 2007/09/13 14:08:30 bicatali Exp $

inherit eutils elisp-common autotools fdo-mime

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
	clisp? ( >=dev-lisp/clisp-2.33.2-r1 )
	gcl?   ( >=dev-lisp/gcl-2.6.7 )
	sbcl?  ( >=dev-lisp/sbcl-0.9.4 app-misc/rlwrap )
	cmucl? ( >=dev-lisp/cmucl-19a app-misc/rlwrap )
	!clisp? ( !sbcl? ( !cmucl? ( >=dev-lisp/gcl-2.6.7 ) ) )
	tk? ( >=dev-lang/tk-8.3.3 )"

DEPEND="${RDEPEND} >=sys-apps/texinfo-4.3"
# the make install already strips maxima exec.
RESTRICT="strip"

for lang in es pt; do
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

			for strippedpath in ${TEXMFPATH}
			do
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
		elog "enable the png and gd USE flags enabled for"
		elog "both sci-visualization/gnuplot and media-libs/gd"
		elog "Then re-emerge maxima"
		epause 5
	fi

	# enable gcl if no other lisp selected
	if use gcl || (! use cmucl && ! use clisp && ! use sbcl ); then
		if ! built_with_use dev-lisp/gcl ansi; then
			eerror "GCL must be installed with ANSI."
			eerror "Try USE=\"ansi\" emerge gcl"
			die "This package needs gcl with USE=ansi"
		fi
		enablegcl="--enable-gcl"
	fi
}

src_unpack() {
	unpack ${A}
	# use xdg-open to view html, ps, pdf
	epatch "${FILESDIR}/${P}-xdg-utils.patch"
	# diff_form autoloading
	epatch "${FILESDIR}/${P}-diff_form.patch"
}

src_compile() {
	# automake version mismatch otherwise (sbcl only)
	use sbcl && eautoreconf

	# remove rmaxima if neither cmucl nor sbcl
	if ! use sbcl && ! use cmucl ; then
		sed -i -e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' src/Makefile.in
	fi

	# remove xmaxima if no tk
	local myconf="${enablegcl}"
	if use tk; then
		myconf="${myconf} --with-wish=wish"
	else
		myconf="${myconf} --with-wish=none"
		sed -i -e '/^SUBDIRS/s/xmaxima//' interfaces/Makefile.in
	fi

	# enable existing translated doc
	if use nls; then
		for lang in es pt; do
			if use linguas_${lang}; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf \
		$(use_enable cmucl) \
		$(use_enable clisp) \
		$(use_enable sbcl) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	use emacs && \
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el

	if use tetex; then
		insinto "${MAXIMA_TEXMFDIR}/tex/latex/emaxima"
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS ChangeLog COPYING NEWS README*
	dodir /usr/share/doc
	dosym /usr/share/${PN}/${PV}/doc /usr/share/doc/${PF}
}

pkg_preinst() {
	# some lisp do not gunzip info files on the fly
	if use cmucl || use clisp || use sbcl; then
		for infofile in $(ls ${D}/usr/share/info/*.gz); do
			gunzip ${infofile}
		done
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use tetex && mktexlsr
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	use emacs && elisp-site-regen
	fdo-mime_desktop_database_update
}
