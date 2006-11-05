# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/asis-gcc/asis-gcc-3.4.6.ebuild,v 1.2 2006/11/05 15:13:11 george Exp $

inherit eutils flag-o-matic gnatbuild

DESCRIPTION="The Ada Semantic Interface Specification (semantic analysis and tools tied to compiler). GnuAda version"
HOMEPAGE="http://gnuada.sourceforge.net/"
LICENSE="GMGPL"

KEYWORDS="~amd64 ~x86"

Gnat_Name="gnat-gcc"
My_PN="asis"
My_PV="3.4.4"

SRC_URI="http://mirrors/gentoo/${My_PN}-${My_PV}.tar.bz2"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gcc-${PV}*"
DEPEND="${RDEPEND}
	doc? ( virtual/tetex
	app-text/texi2html )"

S="${WORKDIR}/${My_PN}-${My_PV}"

# Execstack is not nearly as dangerous in Ada as in C and would require a lot of
# work to work around. See bug #141315.
QA_EXECSTACK="usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis-${SLOT}.so
	usr/lib/gnat-gcc/*/${SLOT}/adalib/libasis.a
	usr/*/gnat-gcc-bin/${SLOT}/*"


# it may be even better to force plain -O2 -pipe -ftracer here
replace-flags -O3 -O2


pkg_setup() {
	currGnat=$(eselect --no-color gnat show | grep "gnat-" | awk '{ print $1 }')
	if [[ "${currGnat}" != "${CTARGET}-${Gnat_Name}-${SLOT}" ]]; then
		echo
		eerror "The active gnat profile does not correspond to the selected"
		eerror "version of asis!  Please install the appropriate gnat (if you"
		eerror "did not so yet) and run:"
		einfo  "eselect gnat set ${CTARGET}-${Gnat_Name}-${SLOT}"
		einfo  "env-update && source /etc/profile"
		eerror "and then emerge =dev-ada/asis-${PV} again.."
		echo
		die
	fi
}

src_unpack() {
	unpack ${A}
}

src_compile() {
	# Build the shared library first, we need -fPIC here
	gnatmake -Pasis  -cargs ${CFLAGS} || die "building libasis.a failed"
	gnatmake -Pasis_dyn -f -cargs ${CFLAGS} || die "building libasis.so failed"

	# build tools
	# we need version.o generated for all the tools
	gcc -c -o obj/version.o gnat/version.c
	for fn in asistant gnatelim gnatstub ; do
		pushd tools/${fn}
			gnatmake -o ${fn} ${fn}-driver.adb -I../../asis/ -I../../gnat/ \
				-L../../lib -cargs ${CFLAGS} -largs -lasis ../../obj/version.o \
				|| die "building ${fn} failed"
		popd
	done

	pushd tools/adabrowse
		gcc -c util-nl.c
		gnatmake -I../../asis -I../../gnat adabrowse -L../../lib -cargs	${CFLAGS} \
			-largs -lasis ../../obj/version.o || die
	popd
	pushd tools/semtools
		gnatmake -I../../asis -I../../gnat adadep -L../../lib \
			-cargs ${CFLAGS} -largs -lasis ../../obj/version.o || die
		gnatmake -I../../asis -I../../gnat adasubst -L../../lib \
			-cargs ${CFLAGS} -largs -lasis ../../obj/version.o || die
	popd

	# common stuff is just docs in this case
	if use doc; then
		pushd documentation
		make all || die "Failed while compiling documentation"
		for fn in *.ps; do ps2pdf ${fn}; done
		popd
	fi
}


src_install () {
	# we need to adjust some vars defined in gnatbuild.eclass so that they use
	# gnat-gcc instead of asis
	LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
	BINPATH=${BINPATH/${PN}/${Gnat_Name}}
	DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

	# install the lib
	dodir ${LIBPATH}/adalib
	chmod 0755 lib_dyn/libasis.so
	cp lib_dyn/libasis.so ${D}${LIBPATH}/adalib/libasis-${SLOT}.so
	insinto ${LIBPATH}/adalib
	doins obj/*.ali
	doins lib/libasis.a
	# make appropriate symlinks
	pushd ${D}${LIBPATH}/adalib
	ln -s libasis-${SLOT}.so libasis.so
	popd
	# sources
	insinto ${LIBPATH}/adainclude
	doins gnat/*.ad[sb]
	doins asis/*.ad[sb]

	# tools
	mkdir -p ${D}${BINPATH}
	for fn in tools/{adabrowse,asistant,gnatelim,gnatstub}; do
		cp ${fn}/${fn:6} ${D}${BINPATH}
	done
	cp tools/semtools/ada{dep,subst} ${D}${BINPATH}

	if use doc; then
		# docs and examples
		dodoc documentation/*.{txt,ps}
		dohtml documentation/*.html
		# info's should go into gnat-gpl dirs
		insinto ${DATAPATH}/info/
		doins documentation/*.info
	fi

	insinto /usr/share/doc/${PF}
	doins -r documentation/*.pdf examples/ tutorial/ templates/
}

pkg_postinst() {
	echo
	einfo "The ASIS is installed for the active gnat compiler at gnat's	location."
	einfo "No further configuration is necessary. Enjoy."
	echo
}
