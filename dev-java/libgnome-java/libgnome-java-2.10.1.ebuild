# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libgnome-java/libgnome-java-2.10.1.ebuild,v 1.1 2005/05/01 16:42:39 karltk Exp $

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
RDEPEND=">=gnome-base/libgnome-2.10.0
	>=gnome-base/libgnomeui-2.10.0
	>=gnome-base/libgnomecanvas-2.10.0
	>=dev-java/libgtk-java-2.6.2
	>=virtual/jre-1.2"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.2
	app-arch/zip"

#
# Critical that this match the gnome apiversion
#
SLOT="2.10"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc"
IUSE="gcj"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/libgnome-java-2.10.0_fix-install-dir.patch

	sed -i \
		-e "s:/share/${PN}/:/share/${PN}-${SLOT}/:" \
		-e "s:/share/java/:/share/${PN}-${SLOT}/lib/:" \
		configure || die "sed configure error"
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

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--with-jardir=/usr/share/${PN}-${SLOT}/lib \
			${conf} || die "./configure failed"
	make || die
}

src_install() {
	# workaround Makefile bug not creating necessary parent directories

	make DESTDIR=${D} install || die "install step failed"

	# actually, at time of writing, there were no DOCUMENTS, but leave it here...
	mv ${D}/usr/share/doc/libgnome${SLOT}-java ${D}/usr/share/doc/${PF}

	dodir /usr/share/${PN}-${SLOT}/src
	cd ${S}/src/java
	find . -name '*.java' | xargs zip ${D}/usr/share/${PN}-${SLOT}/src/libgnome-java-${PV}.src.zip

	# again, with dojar misbehaving, better do to this manually for the 
	# time being. Yes, this is bad hard coding, but what in this ebuild isn't?

	echo "DESCRIPTION=${DESCRIPTION}" \
		>  ${D}/usr/share/${PN}-${SLOT}/package.env

	echo "CLASSPATH=/usr/share/${PN}-${SLOT}/lib/gnome${SLOT}.jar" \
		>> ${D}/usr/share/${PN}-${SLOT}/package.env
}
