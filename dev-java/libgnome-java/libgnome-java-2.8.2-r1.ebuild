# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libgnome-java/libgnome-java-2.8.2-r1.ebuild,v 1.3 2005/03/12 21:14:23 luckyduck Exp $

#
# WARNING: Because java-gnome is a set of bindings to native GNOME libraries,
# it has, like any GNOME project, a massive autoconf setup, and unlike many
# other java libraries, it has its own [necessary] `make install` step.
# As a result, this ebuild is VERY sensitive to the internal layout of the
# upstream project. Because these issues are currently evolving upstream,
# simply version bumping this ebuild is not likely to work but FAILURES WILL
# BE VERY SUBTLE IF IT DOES NOT WORK.
#

inherit eutils gnome.org

DESCRIPTION="Java bindings for the core GNOME libraries (allow GNOME/GTK applications to be written in Java)"
HOMEPAGE="http://java-gnome.sourceforge.net/"
RDEPEND=">=gnome-base/libgnome-2.8.0
	>=gnome-base/libgnomeui-2.8.0
	=dev-java/libgtk-java-2.4.6*
	>=virtual/jre-1.2"

#
# Unfortunately we need to run autogen to do the variable substitutions, so
# regardless of whether or not there is an upstream ./configure [at time of
# writing there isn't] we need to recreate it
#

DEPEND="${RDEPEND}
	>=virtual/jdk-1.2
	app-arch/zip
	sys-devel/autoconf
	sys-devel/automake"

#
# Critical that this match gtkapiversion
#
SLOT="2.8"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="gcj"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/libgnome-java-2.8.2_gentoo-PN-SLOT.patch
	sed -i "s|^\(JAVA_INCLUDES = \)|\1 -I\${JDK_HOME}/include -I\${JDK_HOME}/include/linux/|" src/Makefile.in || die "sed failed"
}

src_compile() {
	local conf

	use gcj	|| conf="${conf} --without-gcj-compile"

	cd ${S}

	#
	# Ordinarily, moving things around post `make install` would do
	# the trick, but there are paths hard coded in .pc files and in the
	# `make install` step itself that need to be influenced.
	#

	./autogen.sh \
		--host=${CHOST} \
		--prefix=/usr \
			${conf} || die "./configure failed"
	make || die "compile failed"
}

src_install() {
	# workaround Makefile bug not creating necessary parent directories
	mkdir -p ${D}/usr/lib
	mkdir -p ${D}/usr/share/java
	mkdir -p ${D}/usr/lib/pkgconfig
	mkdir -p ${D}/usr/share/doc/libgnome${SLOT}-java

	make prefix=${D}/usr install || die

	# actually, at time of writing, there were no DOCUMENTS, but leave it here...
	mv ${D}/usr/share/doc/libgnome${SLOT}-java ${D}/usr/share/doc/${PF}

	# the upstream install scatters things around a bit. The following cleans
	# that up to make it policy compliant.

	# I originally tried java-pkg_dojar here, but it has a few glitches
	# like not copying symlinks as symlinks which makes a mess.

	dodir /usr/share/${PN}-${SLOT}/lib
	mv ${D}/usr/share/java/*.jar ${D}/usr/share/${PN}-${SLOT}/lib
	rm -rf ${D}/usr/share/java

	mkdir ${D}/usr/share/${PN}-${SLOT}/src
	cd ${S}/src/java
	zip -r ${D}/usr/share/${PN}-${SLOT}/src/libgnome-java-${PV}.src.zip *

	# again, with dojar misbehaving, better do to this manually for the
	# time being. Yes, this is bad hard coding, but what in this ebuild isn't?

	echo "DESCRIPTION=${DESCRIPTION}" \
		>  ${D}/usr/share/${PN}-${SLOT}/package.env

	echo "CLASSPATH=/usr/share/${PN}-${SLOT}/lib/gnome${SLOT}.jar" \
		>> ${D}/usr/share/${PN}-${SLOT}/package.env
}
