# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ecletex/ecletex-0.0.3.ebuild,v 1.9 2005/09/02 12:49:59 flameeyes Exp $

inherit eclipse-ext

# karltk: Another Portage feature?
At="${PN}.${PV}.zip"

DESCRIPTION="LaTeX plugin for Eclipse 3.0 and newer"
HOMEPAGE="http://etex.sf.net"
SRC_URI="mirror://sourceforge/etex/${At}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
# karltk: only compiles against 3.0.0
DEPEND=">=virtual/jdk-1.4
	=dev-util/eclipse-sdk-3.0.0*
	app-arch/unzip"
# karltk: runs against any 3.0.x
RDEPEND=">=virtual/jre-1.4
	=dev-util/eclipse-sdk-3.0*"

pkg_setup() {
	stagedir=${S}/final/ish.ecletex_${PV}
	eclipse-ext_require-slot 3 || die "No suitable Eclipse found!"
}

src_unpack() {
	mkdir -p ${S}
	cd ${S}
	unpack ${At}

	cd plugins/ish.ecletex_${PV} || die "Unpacked file bad"

	rm ecletex.jar ecletexsrc.zip

	echo "temp.folder=dist" > build.properties || die "Failed to create build.propertes"

	cp ${FILESDIR}/build.xml-${PV} build.xml || die "Failed to add build.xml"

	x="$(eclipse-ext_get-classpath build.properties)"
	y=$(eclipse-ext_resolve-jars "$x")

	echo "classpath = $y" > build.properties


	mkdir -p ${stagedir}
}

src_compile() {

	cd plugins/ish.ecletex_${PV}

	ant build.jars || die "Failed to build main plugin"
	ant ecletexsrc.zip || die "Failed to build source .zip"

	cp ecletexsrc.zip ecletex.jar plugin.xml ${stagedir} || \
		die "Failed to copy build products"

	for x in codeassist dictionary icons templates ; do
		cp -pR $x ${stagedir}/ || die "Failed to copy directory $x"
	done

}

src_install() {
	eclipse-ext_create-ext-layout source
	eclipse-ext_install-plugins ${stagedir}
}
