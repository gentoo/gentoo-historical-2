# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/metadata-extractor/metadata-extractor-2.2.2.ebuild,v 1.6 2005/07/11 20:22:19 axxo Exp $

inherit java-pkg

DESCRIPTION="A general metadata extraction framework. Support currently exists for Exif and Iptc metadata segments. Extraction of these segments is provided for Jpeg files"
HOMEPAGE="http://www.drewnoakes.com/code/exif/"
SRC_URI="http://www.drewnoakes.com/code/exif/metadata-extractor-${PV}-src.jar"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="junit jikes"

DEPEND=">=virtual/jdk-1.4
		dev-java/ant
		junit? ( dev-java/junit )
		jikes? ( dev-java/jikes )
		sys-apps/sed"
RDEPEND=">=virtual/jre-1.4"
S=${WORKDIR}/

src_unpack() {
	jar xf ${DISTDIR}/${A}
	sed -e "s:clean, compile, test:clean, compile:" -i metadata-extractor.build || die "sed failed"
	mv metadata-extractor.build build.xml
}

src_compile() {
	local antflags="dist-binaries"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use junit && antflags="${antflags} test"
	ant ${antflags} || die "failed to compile"
}

src_install() {
	dodoc ReleaseNotes.txt
	java-pkg_dojar dist/*.jar
}

