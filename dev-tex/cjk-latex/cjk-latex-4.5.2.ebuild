# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/cjk-latex/cjk-latex-4.5.2.ebuild,v 1.15 2006/10/27 17:11:47 gustavoz Exp $

inherit latex-package elisp-common toolchain-funcs

MY_P="${P/-latex/}"

DESCRIPTION="A LaTeX 2e macro package which enables the use of CJK scripts in various encodings"
HOMEPAGE="http://cjk.ffii.org/"
# fonts are taken from ftp://ftp.ctan.org/tex-archive/fonts/CJK.tar.gz
SRC_URI="ftp://ftp.ffii.org/pub/cjk/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-fonts.tar.gz
	doc? ( ftp://ftp.ffii.org/pub/cjk/${MY_P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="doc emacs"

DEPEND="virtual/tetex
	emacs? ( virtual/emacs )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	use doc && unpack ${MY_P}-doc.tar.gz

	cd ${S}
	unpack ${MY_P}-fonts.tar.gz
	rm CJK/han*.300.tar.gz || die
	for f in ${S}/CJK/*.tar.gz; do
		tar --no-same-owner -xzf $f || die
		find texmf/fonts/hbf -type f -exec cp {} ${T} \; || die
	done
	sed -i -e "/^pk_files/s/no/yes/" \
		-e "/^dpi_x/s/300/500/" \
		texmf/hbf2gf/*.cfg || die
}

src_compile() {
	cd utils
	for d in *conv; do
		cd $d
		local f=`echo $d | tr '[:upper:]' '[:lower:]'`
		$(tc-getCC) ${CFLAGS} -o $f $f.c || die
		if [ $d = CEFconv ] ; then
			$(tc-getCC) ${CFLAGS} -o cef5conv cef5conv.c || die
			$(tc-getCC) ${CFLAGS} -o cefsconv cefsconv.c || die
		fi
		cd -
	done
	cd hbf2gf
	econf --with-kpathsea-lib=/usr/lib \
		--with-kpathsea-include=/usr/include/kpathsea || die
	make || die
	cd -

	if use emacs ; then
		cd lisp
		elisp-compile *.el
		cd emacs-20.3
		elisp-compile *.el
	fi

	cd ${T}

	for f in ${S}/texmf/hbf2gf/*.cfg ; do
		env HBF_TARGET=${S}/texmf/fonts ${S}/utils/hbf2gf/hbf2gf $f || die
	done
	for gf in *.gf ; do
		gftopk $gf || die
	done
}

src_install() {
	cd utils
	for d in *conv; do
		cd $d
		local f=`echo $d | tr '[:upper:]' '[:lower:]'`
		dobin *latex *conv
		doman *.1
		cd -
	done
	cd hbf2gf
	einstall || die

	cd ${S}
	dodir ${TEXMF}/tex/latex/${PN}
	cp -pPR texinput/* ${D}/${TEXMF}/tex/latex/${PN} || die
	cp -pPR contrib/wadalab ${D}/${TEXMF}/tex/latex/${PN} || die

	if use emacs ; then
		cd utils/lisp
		elisp-install ${PN} *.el{,c} emacs-20.3/*.el{,c}
		cd -
	fi

	cd ${S}
	for d in texmf/fonts/pk/modeless/*/* ; do
		insinto /usr/share/${d}
		for f in ${T}/${d##*/}*.pk ; do
			newins $f `basename ${f/.pk/.500pk}` \
				|| die "newins failed"
		done
	done
	cp -pPR texmf/fonts/* ${D}/${TEXMF}/fonts || die "cp failed"

	dodoc ChangeLog README doc/*
	docinto chinese; dodoc doc/chinese/*
	docinto japanese; dodoc doc/japanese/*
	if use doc ; then
		docinto cjk; dodoc doc/cjk/*
		insinto /usr/share/doc/${P}/dvi
		doins doc/dvi/*
		insinto /usr/share/doc/${P}/ps
		doins doc/ps/*
	fi

	docinto examples; dodoc examples/*
	if use doc ; then
		docinto examples/cjk; dodoc examples/cjk/*
		insinto /usr/share/doc/${P}/examples/dvi
		doins examples/dvi/*
		insinto /usr/share/doc/${P}/examples/ps
		doins examples/ps/*
	fi
}
