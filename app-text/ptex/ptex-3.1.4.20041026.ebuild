# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ptex/ptex-3.1.4.20041026.ebuild,v 1.1 2004/11/05 16:53:32 usata Exp $

TETEX_PV=2.99.1.20041026
TEXMF_PATH=/var/lib/texmf

inherit tetex eutils

DESCRIPTION="The ASCII publishing TeX distribution"
HOMEPAGE="http://www.ascii.co.jp/pb/ptex/
	http://www.misojiro.t.u-tokyo.ac.jp/~tutimura/ptetex3/0README
	http://www.fsci.fuk.kindai.ac.jp/aftp/pub/ptex/utils/"

PTEX_TEXMF_PV=2.2
PTEX_SRC="ptex-src-${PV%.*}b.tar.gz"
PTEX_TEXMF="ptex-texmf-${PTEX_TEXMF_PV}.tar.gz"
PTETEX=ptetex3-20041027

S=${WORKDIR}/tetex-src-beta-${TETEX_PV}

SRC_PATH_PTEX="ftp://ftp.ascii.co.jp/pub/TeX/ascii-ptex"
SRC_PATH_TETEX="ftp://cam.ctan.org/tex-archive/systems/unix/teTeX-beta"
TETEX_SRC="tetex-src-beta-${TETEX_PV}.tar.gz"
TETEX_TEXMF="tetex-texmf-beta-${TETEX_PV}.tar.gz"
TETEX_TEXMF_SRC=""
SRC_URI="${SRC_PATH_TETEX}/${TETEX_SRC}
	${SRC_PATH_TETEX}/${TETEX_TEXMF}
	http://www.misojiro.t.u-tokyo.ac.jp/~tutimura/ptetex3/${PTETEX}.tar.gz
	mirror://gentoo/tetex-${TETEX_PV}-gentoo.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~x86 ~alpha ~amd64 ~ppc ~sparc ~ppc64 ~ppc-macos"
IUSE="X motif lesstif Xaw3d"

DEPEND="X? ( >=media-libs/freetype-2
		>=media-fonts/kochi-substitute-20030809-r3
		motif? ( lesstif? ( x11-libs/lesstif )
			!lesstif? ( x11-libs/openmotif ) )
		!motif? ( Xaw3d? ( x11-libs/Xaw3d ) )
		!app-text/xdvik
	)"

src_unpack() {
	unpack ${PTETEX}.tar.gz
	tetex_src_unpack

	einfo "Unpacking pTeX sources ..."
	cd ${S}/texmf
	echo ">>> Unpacking ${PTEX_TEXMF} to ${S}/texmf ..."
	tar xzf ${WORKDIR}/${PTETEX}/archive/${PTEX_TEXMF} || die

	cd ${S}/texk/web2c
	echo ">>> Unpacking ${PTEX_SRC} to ${S}/texk/web2c ..."
	tar xzf ${WORKDIR}/${PTETEX}/archive/${PTEX_SRC} || die

	cd ${S}/texk
	echo ">>> Unpacking dvipsk-jpatch to ${S}/texk ..."
	tar xzf ${WORKDIR}/${PTETEX}/archive/dvipsk-5.94b-p1.6a.tar.gz || die
	epatch dvipsk-5.94b-p1.6a.diff

	if use X ; then
		cd ${S}
		epatch ${WORKDIR}/${PTETEX}/archive/xdvik-22.84.4-tetex-20040628-jp.diff.gz
		cat >>${S}/texk/xdvik/vfontmap.sample<<-EOF

		# TrueType fonts
		min     /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		nmin    /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		goth    /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		tmin    /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		tgoth   /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		ngoth   /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		jis     /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		jisg    /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		dm      /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		dg      /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		mgoth   /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		fmin    /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf
		fgoth   /usr/share/fonts/kochi-substitute/kochi-gothic-subst.ttf
		EOF
	fi
}

src_compile() {
	if use X ; then
		export CPPFLAGS="${CPPFLAGS} -I/usr/include/freetype2"

		if use motif ; then
			if use lesstif ; then
				append-ldflags -L/usr/X11R6/lib/lesstif -R/usr/X11R6/lib/lesstif
				export CPPFLAGS="${CPPFLAGS} -I/usr/X11R6/include/lesstif"
			fi
			toolkit="motif"
		elif use Xaw3d ; then
			toolkit="xaw3d"
		else
			toolkit="xaw"
		fi

		TETEX_ECONF="--with-vflib=vf2ft --enable-freetype --with-x-toolkit=${toolkit}"
	fi

	tetex_src_compile

	cat >>${S}/texk/web2c/fmtutil.cnf<<-EOF

	# Japanese pLaTeX:
	ptex		ptex	-		ptex.ini
	platex		ptex	language.dat	platex.ini
	platex209	ptex	language.dat	plplain.ini
	EOF

	cat >>${S}/texk/web2c/texmf.cnf<<-EOF

	CMAPINPUTS = .;/opt/Acrobat5/Resource/Font//;/usr/share/xpdf//
	EOF

	# make ptex.tex visible to ptex
	TEXMF="${S}/texmf" ${S}/texk/kpathsea/mktexlsr || die

	cd ${S}/texk/web2c/${PTEX_SRC%.tar.gz} || die
	chmod +x configure
	./configure EUC || die "configure pTeX failed"

	make || die "make pTeX failed"
}

src_install() {
	tetex_src_install base doc fixup

	einfo "Installing pTeX ..."
	dodir ${D}${TEXMF_PATH}/web2c
	cd ${S}/texk/web2c/${PTEX_SRC%.tar.gz} || die
	einstall bindir=${D}/usr/bin texmf=${D}${TEXMF_PATH} || die

	insinto /usr/share/texmf/fonts/map/dvips/tetex
	doins ${FILESDIR}/psfonts-ja.map || die

	cat >>${D}/${TEXMF_PATH}/web2c/updmap.cfg<<-EOF

	# Japanese fonts
	MixedMap psfonts-ja.map
	EOF

	# ptex reinstalls ${TEXMF_PATH}/web2c
	tetex_src_install link

	docinto dvipsk
	cd ${S}/texk/dvipsk
	dodoc ../ChangeLog.jpatch ../README.jpatch

	if use X ; then
		cd ${S}/texk/xdvik
		docinto xdvik
		dodoc ANNOUNCE BUGS CHANGES.xdvik-jp FAQ README.*
		docinto xdvik/READMEs
		dodoc READMEs/*
	fi
}
