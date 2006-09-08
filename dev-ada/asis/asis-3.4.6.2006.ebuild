# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/asis/asis-3.4.6.2006.ebuild,v 1.2 2006/09/08 16:34:51 george Exp $

inherit eutils flag-o-matic gnatbuild

ACT_Ver=$(get_version_component_range 4)
Gnat_Name="gnat-gpl"

S="${WORKDIR}/asis-${ACT_Ver}-src"
DESCRIPTION="The Ada Semantic Interface Specification (semantic analysis and tools tied to compiler)"
SRC_URI="http://dev.gentoo.org/~george/src/asis-gpl-${ACT_Ver}-src.tgz"

HOMEPAGE="https://libre2.adacore.com/"

LICENSE="GPL-2"

IUSE="doc"
RDEPEND="=dev-lang/gnat-gpl-${PV}*"
DEPEND="${RDEPEND}
	doc? ( virtual/tetex
	app-text/texi2html )"

# saving slot as defined in gnatbuild.eclass
eSLOT=${SLOT}
# To avoid having two packages we combine both te name indication and the slot
# from gnatbuild.eclass in ASIS' SLOT
# eSLOT depends only on PV, so it is really static
SLOT="ACT-${eSLOT}"

KEYWORDS="~amd64 ~x86"
#IUSE="doc"

# it may be even better to force plain -O2 -pipe -ftracer here
replace-flags -O3 -O2


pkg_setup() {
	currGnat=$(eselect --no-color gnat show | grep "gnat-" | awk '{ print $1 }')
	if [[ "${currGnat}" != "${CTARGET}-${Gnat_Name}-${eSLOT}" ]]; then
		echo
		eerror "The active gnat profile does not correspond to the selected"
		eerror "version of asis!  Please install the appropriate gnat (if you"
		eerror "did not so yet) and run:"
		einfo  "eselect gnat set ${CTARGET}-${Gnat_Name}-${eSLOT}"
		eerror "and then emerge =dev-ada/asis-${PV} again.."
		echo
		die
	fi
}

src_unpack() {
	unpack ${A}

	cd ${S}
	sed -i -e "s:\"gcc\":\"gnatgcc\":" asis/a4g-contt.adb
	sed -i -e "s:\"gcc\":\"gnatgcc\":" \
		-e "s:environment settings for gcc:environment for gnatgcc:" \
		asis/a4g-gnat_int.adb
	sed -i -e "s:\"gcc#\":\"gnatgcc#\":" gnat/snames.adb

	sed -i -e "s:gcc:gnatgcc:" tools/tool_utils/asis_ul-common.adb
	sed -i -e "s:\"gcc:\"gnatgcc:" tools/gnatmetric/metrics-compute.adb
}


src_compile() {
	# Build the shared library first, we need -fPIC here
	gnatmake -Pasis_bld -XBLD=prod -XOPSYS=default_Unix -cargs ${CFLAGS} -fPIC \
		|| die "building libasis.a failed"
	gnatgcc -shared -Wl,-soname,libasis-${ACT_Ver}.so \
		-o obj/libasis-${ACT_Ver}.so obj/*.o -lc \
		|| die "building libasis.so failed"

	# build tools
	for fn in tools/*; do
		pushd ${fn}
			gnatmake -P${fn:6}.gpr || die "building ${fn:6} failed"
		popd
	done

	# common stuff is just docs in this case
	if use doc; then
		emake -C documentation all || die "Failed while compiling documentation"
	fi
}


src_install () {
	# we need to adjust some vars defined in gnatbuild.eclass so that they use
	# gnat-gpl instead of asis
	LIBPATH=${LIBPATH/${PN}/${Gnat_Name}}
	BINPATH=${BINPATH/${PN}/${Gnat_Name}}
	DATAPATH=${DATAPATH/${PN}/${Gnat_Name}}

	# install the lib
	mkdir -p ${D}${LIBPATH}/adalib
	chmod 0755 obj/libasis-${ACT_Ver}.so
	cp obj/libasis-${ACT_Ver}.so ${D}${LIBPATH}/adalib
	insinto ${LIBPATH}/adalib
	doins obj/*.ali
	chmod 0644 lib/libasis.a
	newins lib/libasis.a libasis-${ACT_Ver}.a
	# make appropriate symlinks
	cd ${D}${LIBPATH}/adalib
	ln -s libasis-${ACT_Ver}.so libasis.so
	ln -s libasis-${ACT_Ver}.a libasis.a
	cd ${S}
	# sources
	insinto ${LIBPATH}/adainclude
	doins gnat/*.ad[sb]
	doins asis/*.ad[sb]

	# tools
	mkdir -p ${D}${BINPATH}
	for fn in tools/{asistant,gnat*}; do
		cp ${fn}/${fn:6} ${D}${BINPATH}
	done

	# docs and examples
	dodoc documentation/*.txt
	dohtml documentation/*.html
	# info's should go into gnat-gpl dirs
	insinto ${DATAPATH}/info/
	doins documentation/*.info

	insinto /usr/share/doc/${PF}
	doins -r documentation/*.pdf examples/ tutorial/ templates/
}

pkg_postinst() {
	echo
	einfo "The ASIS is installed for the active gnat compiler at gnat's	location."
	einfo "No further configuration is necessary. Enjoy."
	echo
}
