# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/lablgl/lablgl-1.00.ebuild,v 1.15 2004/08/25 21:41:38 mattam Exp $

IUSE="tcltk glut doc"

DESCRIPTION="Objective CAML interface for OpenGL"
HOMEPAGE="http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/lablgl.html"
LICENSE="as-is"

DEPEND=">=dev-lang/ocaml-3.05
	virtual/opengl
	glut? ( media-libs/glut )
	tcltk? ( >=dev-lang/tcl-8.3*
	>=dev-lang/tk-8.3* )"

SRC_URI="http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/${P}.tar.gz"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha ~ia64 amd64 hppa"

pkg_setup()
{
	if ( use tcltk )
	then
		#lablgl requires ocaml compiled with tk support while ocaml has it as an optional dependency
		if ( ! which labltk )
		then
			eerror "It seems you don't have ocaml compiled with tk support"
			eerror ""
			eerror "lablgl requires ocaml be built with tk support."
			eerror ""
			eerror "Please make sure that ocaml is installed with tk support."
			false;
		fi
	fi
}

src_compile() {
	# make configuration file
	cp ${FILESDIR}/${P}-Makefile.config ${S}/Makefile.config || die

	if ! (use glut); then
		sed -i "s/-lglut//" Makefile.config
	fi

	if use tcltk; then
		make togl toglopt
	fi

	if use glut; then
		make glut glutopt
	else
		make lib libopt
	fi
}

src_install () {
	# Makefile do not use mkdir so the library is not installed 
	# but copied as a 'stublibs' file.
	dodir /usr/lib/ocaml/stublibs

	# Same for lablglut's toplevel
	dodir /usr/bin

	BINDIR=${D}/usr/bin
	BASE=${D}/usr/lib/ocaml
	make BINDIR=${BINDIR} INSTALLDIR=${BASE}/lablGL DLLDIR=${BASE}/stublibs install || die

	dodoc README CHANGES COPYRIGHT

	if ( use doc && use tcltk ) then
	    DIR=usr/share/doc/${PF}
	    cp -R Togl/examples/ ${D}/${DIR}/examples.togl
	fi

	if ( use glut ) then
	    cd LablGlut
	    newdoc README README.glut
	    newdoc ChangeLog ChangeLog.glut
	    newdoc CHANGES CHANGES.glut
	    newdoc COPYRIGHT COPYRIGHT.glut
	    newdoc THANKS THANKS.glut
	    newdoc TODO TODO.glut

	    if ( use doc ) then
		DIR=usr/share/doc/${PF}
		cp -R examples ${D}/${DIR}/examples.glut
	    fi
	fi
}
