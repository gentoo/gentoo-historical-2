# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gallery-remote/gallery-remote-1.4.1.ebuild,v 1.3 2005/01/01 15:03:05 eradicator Exp $

inherit java-pkg eutils

DESCRIPTION="Gallery Remote is a client-side Java application that provides users with a rich front-end to Gallery. This application makes it easier to upload images to your Gallery."
HOMEPAGE="http://gallery.sourceforge.net/gallery_remote.php"
SRC_URI="mirror://gentoo/gallery-remote-${PV}-cvs-gentoo.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="jikes"
DEPEND=">=virtual/jdk-1.4
		dev-java/apple-java-extensions-bin
		dev-java/jsx
		dev-java/metadata-extractor
		dev-java/java-config"
RDEPEND="${DEPEND}
		media-gfx/imagemagick
		media-libs/jpeg"

S=${WORKDIR}/gallery_remote

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}.patch
	sed -e "s:lib/metadata-extractor-2.1.jar img/:$(java-config -p metadata-extractor) ../img/:" -i build.xml || die "sed failed"
	cd ${S}/lib
	java-pkg_jar-from apple-java-extensions-bin AppleJavaExtensions.jar
	java-pkg_jar-from jsx jsx.jar JSX1.0.7.4.jar
	java-pkg_jar-from metadata-extractor metadata-extractor-2.2.2.jar metadata-extractor-2.1.jar
}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "failed to compile"
}

src_install() {
	dodoc ChangeLog LICENSE README
	java-pkg_dojar GalleryRemote.jar

	dodir /usr/share/gallery-remote/{imagemagick,jpegtran}
	cp imagemagick/im.properties.preinstalled ${D}/usr/share/gallery-remote/imagemagick/im.properties
	cp jpegtran/jpegtran.preinstalled ${D}/usr/share/gallery-remote/jpegtran/jpegtran.properties
	cp -r img ${D}/usr/share/gallery-remote/

	dodir /usr/bin/
	echo "#!/bin/bash" > ${D}/usr/bin/gallery-remote
	echo "cd /usr/share/gallery-remote/" >> ${D}/usr/bin/gallery-remote
	echo "\$(java-config -J) -jar lib/GalleryRemote.jar"  >> ${D}/usr/bin/gallery-remote
	chmod 755 ${D}/usr/bin/gallery-remote
}
